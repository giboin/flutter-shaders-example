/*
This shader is ported from the original Apple shader presented at WWDC 2024.
For more details, see the session here: https://developer.apple.com/videos/play/wwdc2024/10151/
Credit to Apple for the original implementation.
*/

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;
uniform sampler2D iChannel0;

const float rippleAmplitude = 0.07; // Default amplitude of the ripple
const float fadeAmplitude = 1.5; // Default amplitude of the ripple
const float rippleFrequency = 15.0; // Default frequency of the ripple
const float fadeFrequency = 3; // Default frequency of the ripple
const float rippleDecay = 10.0; // Default decay rate of the ripple
const float fadeDecay = 5.0; // Default decay rate of the ripple
const float speed = 1.0; // Default speed of the ripple

out vec4 fragColor;


void main()
{
    vec2 fragCoord = FlutterFragCoord().xy;

    // Normalize the coordinates
    vec2 uv = fragCoord / iResolution.xy;

    // Get the cursor position and normalize it
    vec2 origin = iMouse.xy / iResolution.xy;

    // Calculate the distance from the origin
    float distance = length(uv - origin);
    // Calculate the delay based on the distance
    float delay = distance / speed;

    // Adjust the time for the delay and clamp to 0
    float time = iTime - delay;
    time = max(0.0, time);

    // Calculate the ripple amount
    float rippleAmount = rippleAmplitude * sin(rippleFrequency * time) * exp(-rippleDecay * time);
    float fadeAmount = fadeAmplitude * sin(fadeFrequency * time) * exp(-fadeDecay * time);

    // Calculate the normalized direction vector
    vec2 n = normalize(uv - origin);

    // Calculate the new position by adding the ripple effect
    vec2 newPosition = uv + rippleAmount * n;

    // Sample the texture at the new position
    vec3 color = texture(iChannel0, newPosition).rgb;

    // Lighten or darken the color based on the ripple amount
    color += 0.1 * (rippleAmount / rippleAmplitude);

    vec3 blue = normalize(vec3(0, 110, 255));
    // Add a fading blue tint to the ripple
    color = mix(color, blue , fadeAmount);

    // Set the fragment color
    fragColor = vec4(color, 1.0);
}