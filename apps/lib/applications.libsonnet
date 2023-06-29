local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.5/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local project = argoCd.argoproj.v1alpha1.appProject;

{

  applications: {
    [app.key]: (
                 if std.length($._config.appNameSuffix) > 0 then
                   application.new(app.key + '-' + $._config.appNameSuffix)
                 else
                   application.new(app.key)
               ) +
               application.metadata.withAnnotations(app.value.annotations) +
               application.metadata.withFinalizers(app.value.finalizers) +
               application.metadata.withNamespace('argocd') +
               application.spec.destination.withNamespace(app.value.destination.namespace) +
               application.spec.destination.withServer(if std.objectHasAll(app.value.destination, 'server') then app.value.destination.server else 'https://kubernetes.default.svc') +
               application.spec.withProject(app.value.project) +
               (
                 if std.objectHasAll(app.value, 'syncPolicy') then
                   application.spec.syncPolicy.automated.withAllowEmpty(app.value.syncPolicy.allowEmpty) +
                   application.spec.syncPolicy.automated.withSelfHeal(app.value.syncPolicy.selfHeal) +
                   application.spec.syncPolicy.automated.withPrune(app.value.syncPolicy.prune)
                 else
                   {
                     spec+: {
                       syncPolicy+: {
                         automated: {},
                       },
                     },
                   }
               ) +
               (
                 if std.objectHasAll(app.value, 'syncOptions') then
                   application.spec.syncPolicy.withSyncOptions(app.value.syncOptions)
                 else {}
               ) +
               (
                 if std.objectHasAll(app.value, 'source') then
                   app.value.source
                 else {
                   spec+: {
                     sources: app.value.sources,
                   },
                 }
               )

    for app in std.objectKeysValues($._config.applications)
    if app.value.enabled
  },
}
