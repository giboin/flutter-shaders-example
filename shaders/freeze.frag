// based on https://www.shadertoy.com/view/MsySzy
// Experiment: Frosted Glass II by Shadmar
// Original by Jack Davenport : https://www.shadertoy.com/view/MtsSWs#

#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float progress;
uniform vec2 freezeEffectCenter;
uniform sampler2D image;

out vec4 fragColor;

#define FROSTYNESS 3.0
#define COLORIZE   1.0
#define COLOR_RGB  0.7,1.0,1.0

float rand(vec2 uv) {

    float a = dot(uv, vec2(92., 80.));
    float b = dot(uv, vec2(41., 62.));

    float x = sin(a) + cos(b) * 51.;
    return fract(x);
}

void main( ) {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 d = texture(image, uv);
    if(progress >= 5.0) {
        fragColor = d;
        return;
    }
    
    vec2 rnd = vec2(rand(uv+d.r*.05), rand(uv+d.b*.05));
    vec2 center = freezeEffectCenter.xy / iResolution.xy;

    //vignette
    vec2 lensRadius = vec2(progress, 0.05);
    float dist = distance(uv.xy, center);
    float vigfin = pow(1.-smoothstep(lensRadius.x, lensRadius.y, dist),2.);

    rnd *= .025*vigfin+d.rg*FROSTYNESS*vigfin;
    uv += rnd;
    vec4 color = mix(texture(image, uv),vec4(COLOR_RGB,1.0),COLORIZE*vec4(rnd.x));
    color.r += 1-color.a;
    color.g += 1-color.a;
    color.b += 1-color.a;
    color.a = 1.0;

        fragColor = color;
    
}