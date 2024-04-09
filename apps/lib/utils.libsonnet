local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;

{
  appTemplate:
    {
      withEnabled:: function(enabled) { enabled: enabled },
      enabled:: true,
      targetRevision:: '',
    } +
    application.spec.source.withTargetRevision('HEAD') +
    application.spec.withProject('platform') +
    application.spec.syncPolicy.automated.withAllowEmpty(true) +
    application.spec.syncPolicy.automated.withSelfHeal(true) +
    application.spec.syncPolicy.automated.withPrune(true) +
    application.spec.syncPolicy.withSyncOptions([
      'CreateNamespace=true',
      'PruneLast=true',
    ]),

  helmTemplate:
    {
      withValueFiles:: function(valueFiles) { valueFiles:: if std.isArray(valueFiles) then valueFiles else [valueFiles] },
      withValueFilesMixin:: function(valueFiles) { valueFiles+:: if std.isArray(valueFiles) then valueFiles else [valueFiles] },
      withTargetRevision:: function(targetRevision) { targetRevision:: targetRevision },
      withEnabled:: function(enabled) { enabled:: enabled },
      withSourcesMixin:: function(repoURL, chart) application.spec.withSourcesMixin(
        application.spec.sources.withRepoURL(repoURL) +
        application.spec.sources.withChart(chart) +
        application.spec.sources.withTargetRevision(self.targetRevision) +
        application.spec.sources.helm.withValueFilesMixin(self.valueFiles)
      ),
      enabled:: true,
      targetRevision:: '',
      valueFiles:: [],
    } +
    application.spec.withProject('platform') +
    application.spec.syncPolicy.automated.withAllowEmpty(true) +
    application.spec.syncPolicy.automated.withSelfHeal(true) +
    application.spec.syncPolicy.automated.withPrune(true) +
    application.spec.syncPolicy.withSyncOptions([
      'CreateNamespace=true',
      'PruneLast=true',
    ]) +
    application.spec.withSources([
      application.spec.sources.withRepoURL('https://github.com/irizzante/management-cluster.git') +
      application.spec.sources.withTargetRevision('main') +
      application.spec.sources.withRef('values'),
    ]),

}
