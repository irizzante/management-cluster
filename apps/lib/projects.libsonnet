local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local project = argoCd.argoproj.v1alpha1.appProject;

{
  projects: {
    [p.key]:
      project.new(p.key) +
      project.metadata.withNamespace('argocd') +
      p.value

    for p in std.objectKeysValues($._config.projects)
  },
}
