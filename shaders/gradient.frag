#version 460 core

#include <flutter/runtime_effect.glsl>

// Is set in dart code with `..setFloat(0, size.width)` and `..setFloat(1, size.height)`
uniform vec2 uSize;

// Is set in dart code with `..setFloat(2, color.r.toDouble())` and so on
uniform vec4 uColor;

out vec4 FragColor;

void main() {
    vec2 pixel = FlutterFragCoord() / uSize;

    vec4 white = vec4(1.0);

    FragColor  = mix(uColor, white, pixel.x);
}