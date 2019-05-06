// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Raindrop Effect Surface"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_DistortionStrength("DistortionStrength", Range( 0 , 1)) = 0.3079214
		_Tiling("Tiling", Range( 0.0001 , 0.002)) = 0.0001
		_RainTexture("Rain Texture", 2D) = "white" {}
		_Color0("Color 0", Color) = (0.4941292,0.4820666,0.6509434,1)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform sampler2D _MainTex;
		uniform float _Tiling;
		uniform sampler2D _RainTexture;
		uniform float _DistortionStrength;
		uniform float4 _Color0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 appendResult25 = (float4(( ase_screenPosNorm.x * _ScreenParams.x * _Tiling ) , ( ase_screenPosNorm.y * _ScreenParams.y * _Tiling ) , 0.0 , 0.0));
			float4 color54 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float4 lerpResult63 = lerp( _Color0 , color54 , ase_screenPosNorm);
			o.Emission = ( tex2D( _MainTex, ( appendResult25 + ( tex2D( _RainTexture, appendResult25.xy ) * _DistortionStrength ) ).xy ) * lerpResult63 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16600
130.4;170.4;1461;443;629.7866;782.1298;1.943684;True;False
Node;AmplifyShaderEditor.CommentaryNode;28;-903.4232,-218.1404;Float;False;822.9584;683.9564;Ajusted Screen Size;6;21;26;22;24;25;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenParams;21;-933.5677,212.0731;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;17;-1026.257,108.4513;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-808.4719,438.8008;Float;False;Property;_Tiling;Tiling;3;0;Create;True;0;0;False;0;0.0001;0;0.0001;0.002;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-461.1281,62.5848;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-488.4851,-148.5905;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-246.0628,-168.1405;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;44;157.2272,-131.8219;Float;True;Property;_RainTexture;Rain Texture;4;0;Create;True;0;0;False;0;0799b253df38f2248ae392fc67593998;0799b253df38f2248ae392fc67593998;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;149.5602,-272.9216;Float;False;Property;_DistortionStrength;DistortionStrength;2;0;Create;True;0;0;False;0;0.3079214;0.3079214;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;489.8258,-468.6557;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;695.7035,-641.2487;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;54;858.928,-387.018;Float;False;Constant;_Tint;Tint;6;0;Create;True;0;0;False;0;1,1,1,1;0.7075472,0.7075472,0.7075472,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;62;816.7233,-214.5972;Float;False;Property;_Color0;Color 0;6;0;Create;True;0;0;False;0;0.4941292,0.4820666,0.6509434,1;0.4941292,0.4820666,0.6509434,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;1144.095,-553.9254;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;33;-723.4113,-573.7725;Float;False;533.9305;262.7496;Comment;2;30;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;63;1183.727,-144.163;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;29;-883.6387,-569.6007;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-587.0869,-541.4117;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinTimeNode;32;-319.3325,300.3102;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;55.22829,-770.7468;Float;True;Property;_DistortionTexture;DistortionTexture;0;0;Create;True;0;0;False;0;0a5b39f2cf742674db9fa7c677235e2f;0a5b39f2cf742674db9fa7c677235e2f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;121.583,114.0318;Float;False;Property;_Contrast;Contrast;5;0;Create;True;0;0;False;0;6.000118;10;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1573.615,-350.1156;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;64;1890.798,-427.7496;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Raindrop Effect Surface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;17;2
WireConnection;24;1;21;2
WireConnection;24;2;26;0
WireConnection;22;0;17;1
WireConnection;22;1;21;1
WireConnection;22;2;26;0
WireConnection;25;0;22;0
WireConnection;25;1;24;0
WireConnection;44;1;25;0
WireConnection;20;0;44;0
WireConnection;20;1;10;0
WireConnection;19;0;25;0
WireConnection;19;1;20;0
WireConnection;3;1;19;0
WireConnection;63;0;62;0
WireConnection;63;1;54;0
WireConnection;63;2;17;0
WireConnection;30;0;29;1
WireConnection;30;1;29;2
WireConnection;2;1;25;0
WireConnection;48;0;3;0
WireConnection;48;1;63;0
WireConnection;64;2;48;0
ASEEND*/
//CHKSM=D48B1AEAB4C76CB7EFB0340299B2439D9A5A9E01