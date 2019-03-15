// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CustomBlinn-Phong"
{
	Properties
	{
		_Glossiness("Glossiness", Range( 0.1 , 5)) = 2.582902
		_Specularity("Specularity", Range( 0.1 , 5)) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TintColor("TintColor", Color) = (0.8962264,0.5199804,0.5199804,1)
		_indirectSpecular("indirect Specular", Float) = 0.18
		_occlusion("occlusion", Range( 0 , 20)) = 0.8705177
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.708966
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float4 _TintColor;
		uniform float _Smoothness;
		uniform float _occlusion;
		uniform float _indirectSpecular;
		uniform float _Glossiness;
		uniform float _Specularity;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float3 newWorldNormal11 = (WorldNormalVector( i , UnpackNormal( tex2D( _TextureSample1, uv_TextureSample1 ) ) ));
			float dotResult8 = dot( ase_worldlightDir , newWorldNormal11 );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_68_0 = ( ase_lightColor.rgb * ase_lightAtten );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode34 = tex2D( _TextureSample0, uv_TextureSample0 );
			UnityGI gi65 = gi;
			float3 diffNorm65 = WorldNormalVector( i , newWorldNormal11 );
			gi65 = UnityGI_Base( data, 1, diffNorm65 );
			float3 indirectDiffuse65 = gi65.indirect.diffuse + diffNorm65 * 0.0001;
			float3 indirectNormal74 = WorldNormalVector( i , newWorldNormal11 );
			Unity_GlossyEnvironmentData g74 = UnityGlossyEnvironmentSetup( _Smoothness, data.worldViewDir, indirectNormal74, float3(0,0,0));
			float3 indirectSpecular74 = UnityGI_IndirectSpecular( data, _occlusion, indirectNormal74, g74 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult4_g1 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult22 = dot( newWorldNormal11 , normalizeResult4_g1 );
			c.rgb = ( ( ( max( dotResult8 , 0.0 ) * float4( temp_output_68_0 , 0.0 ) * tex2DNode34 * _TintColor ) + float4( ( indirectDiffuse65 * 0.27 ) , 0.0 ) ) * float4( ( ( indirectSpecular74 * _indirectSpecular ) + ( pow( max( dotResult22 , 0.0 ) , exp2( _Glossiness ) ) * _Specularity * temp_output_68_0 ) ) , 0.0 ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode34 = tex2D( _TextureSample0, uv_TextureSample0 );
			o.Emission = ( UNITY_LIGHTMODEL_AMBIENT * tex2DNode34 ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
927.2;73.6;607;711;649.4208;-426.8817;1.958289;False;False
Node;AmplifyShaderEditor.CommentaryNode;39;-353.9341,-227.728;Float;False;844.0126;632.3253;Diffuse;8;15;11;8;65;38;70;85;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;56;-757.8304,182.2403;Float;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;False;0;77fdad851e93f394c9f8a1b1a63b56f3;77fdad851e93f394c9f8a1b1a63b56f3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;30;-730.7625,830.3932;Float;False;1177.806;768.9078;Specular;13;31;32;29;23;28;21;22;87;82;74;111;112;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;11;-418.9254,170.008;Float;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;21;-688.0789,1197.714;Float;False;Blinn-Phong Half Vector;-1;;1;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;15;-356.381,-53.06307;Float;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;37;-205.9732,440.5086;Float;False;513.8724;319.2606;receiveLightInfo;3;2;1;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-667.7231,1468.74;Float;False;Property;_Glossiness;Glossiness;0;0;Create;True;0;0;False;0;2.582902;30;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;22;-433.2387,1173.858;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;28;-365.5029,1469.663;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-515.0001,921.2953;Float;False;Property;_Smoothness;Smoothness;10;0;Create;True;0;0;False;0;0.708966;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;114;-199.4702,1118.44;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-571.8728,1021.215;Float;False;Property;_occlusion;occlusion;9;0;Create;True;0;0;False;0;0.8705177;0.7242041;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;8;-66.77751,-78.07119;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;1;-170.1204,482.0099;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightAttenuation;2;-178.8857,639.7883;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;70;150.057,-63.66829;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;56.53391,507.0778;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectSpecularLight;74;-194.848,776.2463;Float;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;29;-16.02448,1094.499;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;38.90788,316.6653;Float;False;Constant;_5;.5;7;0;Create;True;0;0;False;0;0.27;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-127.8357,1490.476;Float;False;Property;_Specularity;Specularity;5;0;Create;True;0;0;False;0;1;11;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-636.8461,-484.0287;Float;False;Property;_TintColor;TintColor;7;0;Create;True;0;0;False;0;0.8962264,0.5199804,0.5199804,1;0.6415094,0.09985761,0.09985761,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectDiffuseLighting;65;-75.33044,204.9643;Float;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-135.3651,1013.448;Float;False;Property;_indirectSpecular;indirect Specular;8;0;Create;True;0;0;False;0;0.18;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-720.4484,-736.9561;Float;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;332.0924,-117.101;Float;True;4;4;0;FLOAT;1;False;1;FLOAT3;1,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;423.4297,176.0814;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;40;-202.0904,-819.5202;Float;False;644.0985;341.2678;AmbienceLightInfo;2;36;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;272.4224,1075.161;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;244.1321,838.0248;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;630.0245,-48.06326;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;33;-137.3747,-801.6937;Float;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;638.0768,337.9243;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;229.7939,-684.6688;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;913.778,207.9517;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;69;1117.891,471.9211;Float;False;Blinn-Phong Light;1;;2;cf814dba44d007a4e958d2ddd5813da6;0;3;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;43;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;57
Node;AmplifyShaderEditor.Vector3Node;72;-985.3754,202.9737;Float;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;61;1123.833,-205.9954;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;CustomBlinn-Phong;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;56;0
WireConnection;22;0;11;0
WireConnection;22;1;21;0
WireConnection;28;0;23;0
WireConnection;114;0;22;0
WireConnection;8;0;15;0
WireConnection;8;1;11;0
WireConnection;70;0;8;0
WireConnection;68;0;1;1
WireConnection;68;1;2;0
WireConnection;74;0;11;0
WireConnection;74;1;82;0
WireConnection;74;2;87;0
WireConnection;29;0;114;0
WireConnection;29;1;28;0
WireConnection;65;0;11;0
WireConnection;38;0;70;0
WireConnection;38;1;68;0
WireConnection;38;2;34;0
WireConnection;38;3;41;0
WireConnection;85;0;65;0
WireConnection;85;1;86;0
WireConnection;31;0;29;0
WireConnection;31;1;32;0
WireConnection;31;2;68;0
WireConnection;112;0;74;0
WireConnection;112;1;111;0
WireConnection;26;0;38;0
WireConnection;26;1;85;0
WireConnection;110;0;112;0
WireConnection;110;1;31;0
WireConnection;36;0;33;0
WireConnection;36;1;34;0
WireConnection;113;0;26;0
WireConnection;113;1;110;0
WireConnection;61;2;36;0
WireConnection;61;13;113;0
ASEEND*/
//CHKSM=C49576F1C1B55ABAA3BF234F03DA0D2DA717536D