// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MovingShaderW/Vertex"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Color0("Color 0", Color) = (1,1,1,0)
		_Frequency("Frequency", Float) = 1
		_Amplitude("Amplitude", Vector) = (0,0,0,0)
		_VertexWeight("Vertex Weight", Range( 0 , 100)) = 1
		_PositionalOffset("Positional Offset ", Vector) = (0,0,0,0)
		_PositionalAmplitude("Positional Amplitude", Vector) = (0,0.2,0,0)
		_AmplitudeOffset("Amplitude Offset", Float) = 0
		_TimeOffset("Time Offset", Float) = 0
		_NoiseAmount("NoiseAmount", Float) = 0
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

		uniform float _Frequency;
		uniform float _TimeOffset;
		uniform float3 _PositionalOffset;
		uniform float3 _PositionalAmplitude;
		uniform float _VertexWeight;
		uniform float3 _Amplitude;
		uniform float _NoiseAmount;
		uniform float _AmplitudeOffset;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color0;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 break48 = ( ase_vertex3Pos * _PositionalOffset );
			float simplePerlin2D74 = snoise( ase_vertex3Pos.xy );
			v.vertex.xyz += ( ( sin( ( ( _Time.y * _Frequency ) + _TimeOffset + break48.x + break48.y + break48.z ) ) * ( ( ase_vertex3Pos.x * _PositionalAmplitude.x ) + ( ase_vertex3Pos.y * _PositionalAmplitude.y ) + ( ase_vertex3Pos.z * _PositionalAmplitude.z ) ) * ( v.color.r * _VertexWeight * ase_vertex3Pos ) * _Amplitude * ( ( simplePerlin2D74 + _CosTime.z + _SinTime.y + -_SinTime.w + -_CosTime.x ) * _NoiseAmount ) ) + _AmplitudeOffset );
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
0.8;0.8;1534;800;3088.154;-39.66367;1.983202;True;False
Node;AmplifyShaderEditor.CommentaryNode;20;-2714.667,24.41934;Float;False;894.821;386.3248;Scales Vertex Position;4;14;15;46;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1762.441,-270.839;Float;False;886.4168;760.3423;change vertex positions by the value of sin time;3;7;4;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-1670.291,507.354;Float;False;1132.754;970.8624;Noise;8;95;96;94;74;87;85;103;92;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;46;-2674.417,63.1496;Float;False;Property;_PositionalOffset;Positional Offset ;5;0;Create;True;0;0;False;0;0,0,0;-16.07,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;14;-2713.499,242.4124;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;21;-1643.745,-220.839;Float;False;445.2703;331.1159;Time offset and frequency of wave;4;1;3;6;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-1591.409,-170.839;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1593.745,-78.0056;Float;False;Property;_Frequency;Frequency;2;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2310.8,84.9579;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinTimeNode;85;-1540.743,1300.816;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CosTime;87;-1564.948,1117.434;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;74;-1620.291,992.7219;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;103;-1338.87,1095.68;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;71;-2806.021,653.7476;Float;False;Property;_PositionalAmplitude;Positional Amplitude;6;0;Create;True;0;0;False;0;0,0.2,0;0,0.1,0.24;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;92;-1314.291,1186.286;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1722.271,-20.91119;Float;False;Property;_TimeOffset;Time Offset;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1363.274,-133.2074;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-2788.15,439.6107;Float;False;928.9563;560.5059;Use distance from origin as scalar multipllier of amplitude;3;54;55;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;90;-1777.397,-736.1151;Float;False;608.0653;374.3871;Vertex Color;3;42;40;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;48;-2116.927,78.30788;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2180.774,609.8059;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;-1161.128,717.487;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-896.4603,870.4244;Float;False;Property;_NoiseAmount;NoiseAmount;9;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;40;-1607.178,-686.1151;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2177.44,431.965;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1176.617,-109.8508;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-858.8182,-136.0375;Float;False;521.3302;486.3329;sin wave offset and amplitude;3;11;5;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1727.397,-503.8825;Float;False;Property;_VertexWeight;Vertex Weight;4;0;Create;True;0;0;False;0;1;22;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-2109.808,785.7454;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1837.779,537.6876;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1334.132,-516.528;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-702.3365,557.354;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;72;-853.2291,164.4157;Float;False;Property;_Amplitude;Amplitude;3;0;Create;True;0;0;False;0;0,0,0;1,0.5,3.53;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinOpNode;4;-1029.413,-122.8998;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-647.7796,-91.3611;Float;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-588.2104,203.4343;Float;False;Property;_AmplitudeOffset;Amplitude Offset;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;63;-294.6414,-562.2508;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;e02386fa448ae294197e7aa80993802f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;26;-269.5383,-333.6278;Float;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;45.52964,-346.8227;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-421.3443,12.82795;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;224.6489,-68.02621;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MovingShaderW/Vertex;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;14;0
WireConnection;15;1;46;0
WireConnection;74;0;14;0
WireConnection;103;0;87;1
WireConnection;92;0;85;4
WireConnection;6;0;1;0
WireConnection;6;1;3;0
WireConnection;48;0;15;0
WireConnection;54;0;14;2
WireConnection;54;1;71;2
WireConnection;94;0;74;0
WireConnection;94;1;87;3
WireConnection;94;2;85;2
WireConnection;94;3;92;0
WireConnection;94;4;103;0
WireConnection;18;0;14;1
WireConnection;18;1;71;1
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;7;2;48;0
WireConnection;7;3;48;1
WireConnection;7;4;48;2
WireConnection;55;0;14;3
WireConnection;55;1;71;3
WireConnection;51;0;18;0
WireConnection;51;1;54;0
WireConnection;51;2;55;0
WireConnection;42;0;40;1
WireConnection;42;1;44;0
WireConnection;42;2;14;0
WireConnection;95;0;94;0
WireConnection;95;1;96;0
WireConnection;4;0;7;0
WireConnection;5;0;4;0
WireConnection;5;1;51;0
WireConnection;5;2;42;0
WireConnection;5;3;72;0
WireConnection;5;4;95;0
WireConnection;64;0;63;0
WireConnection;64;1;26;0
WireConnection;10;0;5;0
WireConnection;10;1;11;0
WireConnection;0;0;64;0
WireConnection;0;11;10;0
ASEEND*/
//CHKSM=F4C6BDD549E67FAB986EAD640B042DA77BE99079