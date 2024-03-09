#include <flutter/runtime_effect.glsl>

out vec4 fragColor;
uniform sampler2D image;
uniform vec2 iResolution;
uniform float iTime;
uniform float percentage;
uniform float darkPercentage;
uniform float radiusPercentage;


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(void)
{
    vec2 pos = gl_FragCoord.xy;
    vec2 uv = pos / iResolution.xy;

    vec2 center = vec2(iResolution.x * 0.5, iResolution.y * 0.5);
    float radius = iResolution.x * radiusPercentage;
    float maxRadius = iResolution.x * 0.3;
    vec2 offset = pos - center;
    float dist = length(offset);

    if (dist < radius) {
        fragColor = texture(image, uv);
    } else {
        float r = rand(uv * iTime) * percentage;
        float smoothTransition = smoothstep(radius, maxRadius, dist);
        vec4 originalColor = texture(image, uv);
        float grayValue = (originalColor.r + originalColor.g + originalColor.b) / 3.0;
        vec4 gray = vec4(grayValue, grayValue, grayValue, 1.0);
        vec4 desaturatedColor = mix(originalColor, gray, smoothTransition * percentage);
        vec4 darkerColor = mix(desaturatedColor, vec4(0.0, 0.0, 0.0, 1.0), smoothTransition * percentage * darkPercentage);
        fragColor = mix(darkerColor, darkerColor * r, smoothTransition * percentage);
    }
}