Texture2D tex : register(t0);
SamplerState smp : register(s0);
Texture2D normalTex : register(t1);

cbuffer gloabl
{
	float4x4 matWVP;
	float4x4 matNormal;
	float4x4 matW;
	float4	 color;
	float4	 camPos;
	bool	 isTexture;
	float	 scroll;
};

struct VS_OUT
{
	float4 pos : SV_POSITION;
	float2 uv  : TEXCOORD;
	float4 V : TEXCOORD1;
	float4 light : TEXCOORD2;
};

//���_�V�F�[�_�[
VS_OUT VS(float4 pos : POSITION, float4 uv : TEXCOORD, float4 normal : NORMAL, float4 tangent : TANGENT)
{
	VS_OUT outData;
	outData.pos = mul(pos, matWVP);
	outData.uv = uv;

	float3 binormal = cross(normal, tangent);

	normal.w = 0;
	normal = mul(normal, matNormal);
	normal = normalize(normal);

	tangent.w = 0;
	tangent = mul(tangent, matNormal);
	tangent = normalize(tangent);

	binormal = mul(binormal, matNormal);
	binormal = normalize(binormal);


	float4 eye = normalize(mul(pos, matW) - camPos);
	outData.V.x = dot(eye, tangent);
	outData.V.y = dot(eye, binormal);
	outData.V.z = dot(eye, normal);
	outData.V.w = 0;

	float4 light = float4(1, 3, 1, 0);
	light = normalize(light);
	outData.light.x = dot(light, tangent);
	outData.light.y = dot(light, binormal);
	outData.light.z = dot(light, normal);
	outData.light.w = 0;

	return outData;
}

//�s�N�Z���V�F�[�_�[
float4 PS(VS_OUT inData) : SV_TARGET
{
	inData.light = normalize(inData.light);

	float4 diffuse;
	float4 ambient;
	float4 specular;


	float2 uv1 = inData.uv;
	uv1.x += scroll;
	float4 normal1 = normalTex.Sample(smp, uv1) * 2 - 1;

	float2 uv2 = inData.uv;
	uv2.x -= scroll * 0.3;
	uv2.y *= 1.2;
	float4 normal2 = normalTex.Sample(smp, uv2) * 2 - 1;

	float4 normal = normal1 + normal2;
	normal.w = 0;
	normal = normalize(normal);


	float4 S = dot(inData.light,normal);
	S = clamp(S, 0, 1);


	float4 R = reflect(inData.light, normal);
	specular = pow(clamp(dot(R, inData.V), 0, 1), 5) * 3;

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

	result.a = (result.r + result.g + result.b) / 3;

	return result;
}