#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float progress; // 0.0 -> light on the left, 0.5 -> light nowhere , 1.0 -> light on the right
uniform sampler2D image;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 color = texture(image, uv);

    // Calculate the light position based on progress
    float lightX = progress;
    
    // Calculate the distance from the current pixel to the light position
    float dist = abs(uv.x - lightX);
    
    // Create a smooth falloff for the reflection
    float reflection = smoothstep(0.5, 0.0, dist);
    
    // Add a slight vertical gradient to make it look more realistic
    float verticalFalloff = smoothstep(0.0, 1.0, abs(uv.y - 0.5) * 2.0);
    reflection *= (1.0 - verticalFalloff * 0.5);
    
    // Add the reflection to the original color
    vec3 reflectionColor = vec3(1.0, 1.0, 1.0) * reflection * 0.3;
    color.rgb = color.rgb + reflectionColor;

    fragColor = color;
}