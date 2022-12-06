Texture2D tex : register(t0);
SamplerState smp : register(s0);

cbuffer gloabl
{
	float4x4 matWVP;
	float4x4 matNormal;
	float4x4 matW;
	float4	 color;
	float4	 camPos;
	bool	 isTexture;
};

struct VS_OUT
{
	float4 pos : SV_POSITION;
	float2 uv  : TEXCOORD;
	float4 normal : NORMAL;
	float4 V : TEXCOORD1;
};

//頂点シェーダー
VS_OUT VS(float4 pos : POSITION, float4 uv : TEXCOORD, float4 normal : NORMAL)
{
	VS_OUT outData;
	outData.pos = mul(pos, matWVP);
	outData.uv = uv;


	normal.w = 0;
	outData.normal = mul(normal, matNormal);
	outData.normal = normalize(outData.normal);

	outData.V = normalize(mul(pos, matW) - camPos);

	return outData;
}

//ピクセルシェーダー
float4 PS(VS_OUT inData) : SV_TARGET
{
	float4 diffuse;
	float4 ambient;
	float4 specular;

	float4 light = float4(1, 1, -1, 0);
	light = normalize(light);

	float4 S = dot(inData.normal, light);
	S = clamp(S, 0, 1);


	float4 R = reflect(light, inData.normal);
	specular = pow(clamp(dot(R, inData.V), 0, 1), 10) * 3;

	float alpha;

	if (isTexture)
	{
		diffuse = tex.Sample(smp, inData.uv) * S;
		ambient = tex.Sample(smp, inData.uv) * 0.2;
		alpha = tex.Sample(smp, inData.uv).a;
	}
	else
	{
		diffuse = color * S;
		ambient = color * 0.2;
		alpha = color.a;
	}

	float4 result = diffuse + ambient + specular;

	result.a = alpha;
	
	return result;
}