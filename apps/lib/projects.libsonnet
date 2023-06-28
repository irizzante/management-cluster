local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.5/main.libsonnet';
local project = argoCd.argoproj.v1alpha1.appProject;

{
  projects: {
    [p.key]: project.new(p.key) +
             project.metadata.withNamespace('argocd') +
             project.spec.withDescription(p.value.description) +
             project.spec.withSourceRepos(p.value.sourceRepos) +
             project.spec.withDestinations(p.value.destinations) +
             p.value.extras

    for p in std.objectKeysValues($._config.projects)
  },
}
