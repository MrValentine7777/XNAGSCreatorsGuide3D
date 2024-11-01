//------------------------------------------------------------
// Microsoft® XNA Game Studio Creator's Guide, Second Edition
// by Stephen Cawood and Pat McGee 
// Copyright (c) McGraw-Hill/Osborne. All rights reserved.
// https://www.mhprofessional.com/product.php?isbn=0071614060
//------------------------------------------------------------
float4x4 wvpMatrix : WORLDVIEWPROJ; // world view proj matrix
uniform extern texture textureImage; // store texture

// filter (like a brush) for showing texture
sampler textureSampler = sampler_state
{
    Texture = <textureImage>;
    magfilter = LINEAR; // magfilter - bigger than actual
    minfilter = LINEAR; // minfilter - smaller than actual
    mipfilter = LINEAR;
};

// input to vertex shader
struct VSinput
{
    float4 position : POSITION0; // position semantic x,y,z,w
    float4 color : COLOR0; // color semantic r,g,b,a
    float2 uv : TEXCOORD0; // texture semantic u,v
};

// vertex shader output
struct VStoPS
{
    float4 position : SV_POSITION; // position semantic x,y,z,w
    float4 color : COLOR; // color semantic r,g,b,a
    float2 uv : TEXCOORD0; // texture semantic u,v
};

// pixel shader output
struct PSoutput
{
    float4 color : SV_TARGET; // colored pixel is output
};

// alter vertex inputs
VStoPS VertexShader1(VSinput IN)
{
    VStoPS OUT;
    OUT.position = mul(IN.position, wvpMatrix); // transform object
    OUT.color = IN.color; // send color to p.s.
    OUT.uv = IN.uv; // send uv's to p.s.
    return OUT;
}

// convert color and texture data from vertex shader to pixels
PSoutput PixelShader1(VStoPS IN)
{
    PSoutput OUT;
    OUT.color = tex2D(textureSampler, IN.uv);
    OUT.color *= IN.color; // optional tint
    return OUT;
}

// the shader starts here
technique TextureShader
{
    pass P0
    {
        // declare and initialize vs and ps
        VertexShader = compile vs_5_0 VertexShader1();
        PixelShader = compile ps_5_0 PixelShader1();
    }
}
