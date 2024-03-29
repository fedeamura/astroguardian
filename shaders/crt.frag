#include <flutter/runtime_effect.glsl>

out vec4 fragColor;
uniform sampler2D image;
uniform vec2 uSize;
uniform float iTime;
uniform float iCurve;
uniform float iDistortion;
uniform float iVigor;
uniform float iScanFrequency;
uniform float iScanAmplitude;
uniform float iScanVelocity;
uniform float iScanMultiplier;

vec2 curve(vec2 uv)
{
    float tht  = atan(uv.y, uv.x);
    float r = length(uv);
    // curve without distorting the center
    r /= (1. - iCurve * r * r);
    uv.x = r * cos(tht);
    uv.y = r * sin(tht);
    return .5 * (uv + 1.);
}

void main(void) 
{
    vec2 iResolution = uSize;

    vec2 q = gl_FragCoord.xy / iResolution.xy;
    vec2 uv = q;
    uv = curve(uv * 2. - 1.);
    vec3 oricol = texture(image, vec2(q.x,q.y) ).xyz;
    vec3 col;
    float x = iDistortion;

    col.r = texture(image,vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
    col.g = texture(image,vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
    col.b = texture(image,vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
    col.r += 0.08*texture(image,0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
    col.g += 0.05*texture(image,0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
    col.b += 0.08*texture(image,0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

    col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

    float vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
    col *= vec3(pow(vig,iVigor));

//    col *= vec3(0.95,1.05,0.95);
    col *= 2.8;

    float scans = clamp(iScanFrequency + iScanAmplitude * sin(iScanVelocity * iTime + uv.y * iResolution.y) * iScanMultiplier, 0.0, 1.0);

    float s = pow(scans,1.7);
    col = col*vec3( 0.4+0.7*s) ;

    col *= 1.0+0.01*sin(110.0*iTime);
    if (uv.x < 0.0 || uv.x > 1.0)
        col *= 0.0;
    if (uv.y < 0.0 || uv.y > 1.0)
        col *= 0.0;
	
    col*=1.0-0.65*vec3(clamp((mod(gl_FragCoord.x, 2.0)-1.0)*2.0,0.0,1.0));
	
    float comp = smoothstep( 0.1, 0.9, sin(iTime) );
 
    // Remove the next line to stop cross-fade between original and postprocess
//    col = mix( col, oricol, comp );

    fragColor = vec4(col,1.0);
} 