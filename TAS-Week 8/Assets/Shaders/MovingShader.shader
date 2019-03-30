// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MovingShader"
{
	Properties
	{
		_Color0("Color 0", Color) = (0.764151,0.02523142,0.02523142,0)
		_ApplyToComponent("Apply To Component", Vector) = (1,1,1,0)
		_Frequency("Frequency", Float) = 1
		_AmplitudeOffset("Amplitude Offset", Float) = 0
		_TimeOffset("Time Offset", Float) = 0
		_PositionalOffset("Positional Offset ", Vector) = (0,0,0,0)
		_zpos("zpos", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float3 _ApplyToComponent;
		uniform float _Frequency;
		uniform float _TimeOffset;
		uniform float3 _PositionalOffset;
		uniform float3 _Vector0;
		uniform float _zpos;
		uniform float _AmplitudeOffset;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color0;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 break48 = ( ase_vertex3Pos * _PositionalOffset );
			float3 temp_output_10_0 = ( ( _ApplyToComponent * sin( ( ( _Time.y * _Frequency ) + _TimeOffset + break48.x + break48.y + break48.z ) ) * ( ( ase_vertex3Pos.x * _Vector0.x ) + ( ase_vertex3Pos.y * _Vector0.y ) + ( ase_vertex3Pos.z * _zpos * _Vector0.z ) ) ) + _AmplitudeOffset );
			v.vertex.xyz += temp_output_10_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Albedo = ( tex2D( _TextureSample0, uv_TextureSample0 ) * _Color0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0.8;0.8;1534;800;2193.848;386.2909;1.75295;True;False
Node;AmplifyShaderEditor.CommentaryNode;24;-1762.441,-270.839;Float;False;886.4168;760.3423;change vertex positions by the value of sin time;4;7;4;21;70;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2714.667,24.41934;Float;False;894.821;386.3248;Scales Vertex Position;5;14;38;15;46;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;21;-1643.745,-220.839;Float;False;445.2703;331.1159;Time offset and frequency of wave;4;1;3;6;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;14;-2748.182,46.91895;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;46;-2746.562,194.9206;Float;False;Property;_PositionalOffset;Positional Offset ;6;0;Create;True;0;0;False;0;0,0,0;0,0,24.14;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2415.06,80.7549;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-1591.409,-170.839;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-2788.15,439.6107;Float;False;928.9563;560.5059;Use distance from origin as scalar multipllier of amplitude;7;45;52;54;55;53;18;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1593.745,-78.0056;Float;False;Property;_Frequency;Frequency;2;0;Create;True;0;0;False;0;1;18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1722.271,-20.91119;Float;False;Property;_TimeOffset;Time Offset;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;48;-2116.927,78.30788;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;71;-2786.887,638.854;Float;False;Property;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0,0,0;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;53;-2578.956,854.4112;Float;False;Property;_zpos;zpos;9;0;Create;True;0;0;False;0;1;2.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1363.274,-133.2074;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2373.533,465.2598;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-2374.155,827.2116;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1176.617,-109.8508;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2372.555,628.8114;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-805.7201,-136.0375;Float;False;468.2321;430.2848;sin wave offset and amplitude;3;11;10;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;4;-1029.413,-122.8998;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;30;-1019.988,280.3317;Float;False;Property;_ApplyToComponent;Apply To Component;1;0;Create;True;0;0;False;0;1,1,1;0.58,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1890.317,426.0461;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-700.5685,-65.87614;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-787.7116,155.2809;Float;False;Property;_AmplitudeOffset;Amplitude Offset;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-280.554,-381.025;Float;False;Property;_Color0;Color 0;0;0;Create;True;0;0;False;0;0.764151,0.02523142,0.02523142,0;0.1792453,0.1792453,0.1792453,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-359.6414,-599.2508;Float;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;22;-288.4642,-123.1168;Float;False;215.6;227.4;Applying change to X Axis;1;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-990.2698,-267.5163;Float;False;Property;_Amplitude;Amplitude;4;0;Create;True;0;0;False;0;0;-0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-493.0884,30.51863;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-238.4644,-71.3173;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2730.551,503.0189;Float;False;Property;_XPositionalAmplitudeScalar;XPositional Amplitude Scalar;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2586.957,656.0116;Float;False;Property;_YPos;YPos;8;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;29.54108,88.46336;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2419.771,-40.07307;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;34.69675,-393.8758;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;224.6489,-68.02621;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MovingShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;14;0
WireConnection;15;1;46;0
WireConnection;48;0;15;0
WireConnection;6;0;1;0
WireConnection;6;1;3;0
WireConnection;18;0;14;1
WireConnection;18;1;71;1
WireConnection;55;0;14;3
WireConnection;55;1;53;0
WireConnection;55;2;71;3
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;7;2;48;0
WireConnection;7;3;48;1
WireConnection;7;4;48;2
WireConnection;54;0;14;2
WireConnection;54;1;71;2
WireConnection;4;0;7;0
WireConnection;51;0;18;0
WireConnection;51;1;54;0
WireConnection;51;2;55;0
WireConnection;5;0;30;0
WireConnection;5;1;4;0
WireConnection;5;2;51;0
WireConnection;10;0;5;0
WireConnection;10;1;11;0
WireConnection;13;0;10;0
WireConnection;13;1;10;0
WireConnection;13;2;10;0
WireConnection;29;0;10;0
WireConnection;64;0;63;0
WireConnection;64;1;26;0
WireConnection;0;0;64;0
WireConnection;0;11;10;0
ASEEND*/
//CHKSM=77F89D859D2682FE7E7A9CECC601388A58AA8DE9