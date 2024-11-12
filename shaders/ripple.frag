#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform vec2 uPosition;
uniform float uProgress;
uniform float uAmplitude;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    vec2 center = uPosition / uResolution;
    center.y = 1.0 - center.y;  // Flip Y coordinate
    
    float dist = distance(uv, center);
    float rippleWave = dist * 20.0 - uProgress * 2.0;
    float dropoff = 1.0 - smoothstep(0.0, 0.3 + uProgress * 0.7, dist);
    float displacement = sin(rippleWave) * dropoff * uAmplitude * (1.0 - uProgress);
    
    vec2 direction = normalize(uv - center);
    vec2 newUV = uv + direction * displacement * 0.01;
    newUV = clamp(newUV, 0.0, 1.0);
    
    fragColor = texture(uTexture, newUV);
}