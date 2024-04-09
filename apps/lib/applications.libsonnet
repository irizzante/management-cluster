local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local project = argoCd.argoproj.v1alpha1.appProject;

{

  applications: {
    [app.key]:
      app.value + (
        if std.length($._config.appNameSuffix) > 0 then
          application.new(app.key + '-' + $._config.appNameSuffix)
        else
          application.new(app.key)
      ) +
      application.metadata.withNamespace('argocd') +
      application.metadata.withFinalizers('resources-finalizer.argocd.argoproj.io') +
      application.spec.destination.withServer('https://kubernetes.default.svc')

    for app in std.objectKeysValues($._config.applications)
    if app.value.enabled
  },
}
