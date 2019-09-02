#ifndef VOLUMETRICS
void node_subsurface_scattering(vec4 color,
                                float scale,
                                vec3 radius,
                                float sharpen,
                                float texture_blur,
                                vec3 N,
                                float sss_id,
                                out Closure result)
{
  N = normalize(N);
  vec3 out_diff, out_trans;
  vec3 vN = mat3(ViewMatrix) * N;
  result = CLOSURE_DEFAULT;
  closure_load_ssr_data(vec3(0.0), 0.0, N, viewCameraVec, -1, result);

  eevee_closure_subsurface(N, color.rgb, 1.0, scale, out_diff, out_trans);

  vec3 sss_radiance = out_diff + out_trans;
  /* Not perfect for texture_blur not exactly equal to 0.0 or 1.0. */
  vec3 sss_albedo = mix(color.rgb, vec3(1.0), texture_blur);
  sss_radiance *= mix(vec3(1.0), color.rgb, texture_blur);
  closure_load_sss_data(scale, sss_radiance, sss_albedo, int(sss_id), result);
}
#else
/* Stub subsurface scattering because it is not compatible with volumetrics. */
#  define node_subsurface_scattering
#endif
