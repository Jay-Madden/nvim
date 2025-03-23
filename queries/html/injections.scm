; extends

((attribute
  (attribute_name) @_name
  (quoted_attribute_value
    (attribute_value) @injection.content
    (#set! injection.language "javascript")))
 (#match? @_name "^x-"))

