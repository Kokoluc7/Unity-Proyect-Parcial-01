Shader "Ulsa/BasicColor"
{
    
    properties
    {   
        _MainTex("Main Texture", 2D) = "white"{} 
        _NormalTex("Normal Map", 2D) = "bump"{}
        _Albedo("Albedo", color) = (1, 1, 1, 1)
        _NormalStrength("Normal Value", Range(-4.0, 4.0)) = 1.0
        [HDR]_RimColor("Rim Color", color) = (1, 1, 1, 1)
        _RimStrength("Rim Strength", Range(0.1, 8)) = 1.0
        _SpecStrength("Specular Strength", Range(0, 1)) = 0.5
        _GlossStrength("Gloss Strength", Range(0.1, 8)) = 0.5
        _SpecColor("Specular Color", color) = (1, 1, 1, 1)
    }

    subShader
    {
        Tags{ "RenderType" = "Opaque" }

        CGPROGRAM
        //#pragma surface surf Lambert
        #pragma surface surf BlinnPhong

        fixed4 _Albedo;
        sampler2D _MainTex;
        sampler2D _NormalTex;
        float _NormalStrength;
        fixed4 _RimColor;
        float _RimStrength;
        fixed _SpecStrength;
        fixed _GlossStrength;
        //fixed4 _SpecularColor;

        struct Input
        {
             float4 color: COLOR; 
             float2 uv_MainTex;
             float2 uv_NormalTex;
             float3 viewDir;
        }; 

        void surf(Input IN, inout SurfaceOutput o)
        {
             //o.Albedo = _Albedo.rgb;
             o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Albedo.rgb;
             o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
             o.Normal.z /= _NormalStrength;
             half Rim = 1.0 - saturate(dot(IN.viewDir, o.Normal));
             o.Emission = _RimColor.rgb * pow(Rim, _RimStrength);
             o.Specular = _SpecStrength;
             o.Gloss = _GlossStrength;
        }
        ENDCG 
    }
}
