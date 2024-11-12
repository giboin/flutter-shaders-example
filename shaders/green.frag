#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec4 uColor;

out vec4 FragColor;

void main() {
    vec2 pixel = FlutterFragCoord() / uSize;

    vec4 white = vec4(1.0);

    FragColor  = mix(uColor, white, pixel.x);
}