use wasm_minimal_protocol::*;
use serde::Deserialize;
use serde_json::from_slice;
use std::collections::HashMap;
use std::fmt::Write;
use svg::node::{element::tag::Type, Value};
use svg::parser::Event;

initiate_protocol!();

/// A request describing which SVG elements to modify and which properties to set.
#[derive(Deserialize)]
struct ChangeRequest {
    /// Optional `id` selector to match a single SVG element.
    #[serde(default)]
    target_id: Option<String>,

    /// Optional `class` selector to match SVG elements with this class.
    #[serde(default)]
    target_class: Option<String>,

    /// Attribute updates to apply when a matching element is found.
    /// Example: `{ "stroke": "red", "opacity": "0.5" }`.
    properties: HashMap<String, String>,
}

/// Returns `true` when the current element attributes match the requested id or class.
fn matches_target(attributes: &HashMap<String, Value>, request: &ChangeRequest) -> bool {
    request
        .target_id
        .as_ref()
        .map_or(false, |id| {
            attributes
                .get("id")
                .map_or(false, |value| value.to_string() == *id)
        })
        || request.target_class.as_ref().map_or(false, |class| {
            attributes
                .get("class")
                .map_or(false, |value| {
                    value.to_string().split_whitespace().any(|item| item == class)
                })
        })
}

/// Modify SVG content by applying the requested property updates to matching elements.
///
/// `svg_data` is expected to be UTF-8 SVG bytes. `change_json` must be JSON that
/// deserializes into `ChangeRequest`.
#[wasm_func]
pub fn apply_changes(svg_data: &[u8], change_json: &[u8]) -> Vec<u8> {
    let changes: ChangeRequest = from_slice(change_json).unwrap();
    let svg_str = std::str::from_utf8(svg_data).unwrap();

    let mut modified_svg = String::new();
    for event in svg::read(svg_str).unwrap() {
        match event {
            Event::Tag(tag_name, type_, mut attributes) => {
                let matched = matches_target(&attributes, &changes);

                if matched {
                    for (key, value) in &changes.properties {
                        attributes.insert(key.clone(), value.clone().into());
                    }
                }

                modified_svg.push('<');
                if type_ == Type::End {
                    modified_svg.push('/');
                }
                modified_svg.push_str(tag_name);

                if type_ != Type::End {
                    for (key, value) in &attributes {
                        write!(modified_svg, " {}=\"{}\"", key, value).unwrap();
                    }
                    if type_ == Type::Empty {
                        modified_svg.push_str(" /");
                    }
                }

                modified_svg.push('>');
            }
            Event::Text(text)
            | Event::Comment(text)
            | Event::Declaration(text)
            | Event::Instruction(text) => {
                modified_svg.push_str(text);
            }
            Event::Error(error) => {
                panic!("SVG parse error: {:?}", error);
            }
        }
    }
    modified_svg.into_bytes()
}