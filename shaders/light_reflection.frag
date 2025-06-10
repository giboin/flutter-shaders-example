#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float progress; // 0.0 -> light on the left, 0.5 -> light nowhere , 1.0 -> light on the right
uniform float verticalFalloffFactor;
uniform float horizontalFalloffFactor;
uniform float rayRotation;
uniform float rayIntensity;
uniform float speed;
uniform sampler2D image;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 color = texture(image, uv);

    // Calculate the light position based on progress
    float lightX = (progress < 0.5 ? progress : progress - 0.5);
    lightX = lightX*(3.0+speed*5.0) - 1.0;
    
    // Transform UV coordinates based on rotation
    float angle = rayRotation * 3.14159; // Convert 0-1 to 0-π
    vec2 rotatedUV = vec2(
        cos(angle) * (uv.x - 0.5) - sin(angle) * (uv.y - 0.5) + 0.5,
        sin(angle) * (uv.x - 0.5) + cos(angle) * (uv.y - 0.5) + 0.5
    );
    
    // Calculate the distance from the current pixel to the light position
    float dist = abs(rotatedUV.x - lightX);
    
    // Create a smooth falloff for the reflection
    float reflection = smoothstep(0.3, 0.0, dist * horizontalFalloffFactor*2.0);
    
    // Add a slight vertical gradient to make it look more realistic
    float verticalFalloff = smoothstep(0.0, 1.0, abs(rotatedUV.y - 0.5) * verticalFalloffFactor*5.0);
    reflection *= (1.0 - verticalFalloff * 0.5);
    
    // Add the reflection to the original color
    vec3 reflectionColor = vec3(1.0, 1.0, 1.0) * reflection * rayIntensity;
    color.rgb = color.rgb + reflectionColor;

    fragColor = color;
}