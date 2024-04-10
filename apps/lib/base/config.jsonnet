local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local project = argoCd.argoproj.v1alpha1.appProject;
local utils = import 'utils.libsonnet';

{

  _config+:: {

    applications+: {

      nginx:
        utils.helmTemplate +
        application.metadata.withAnnotations({
          'argocd.argoproj.io/sync-wave': '-10',
        }) +
        application.spec.destination.withNamespace('nginx') +
        utils.helmTemplate.withSourcesMixin('https://kubernetes.github.io/ingress-nginx', 'ingress-nginx', self.nginx.targetRevision, self.nginx.valueFiles) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/base/nginx/values.yaml') +
        utils.helmTemplate.withTargetRevision(importstr 'base/nginx/version.txt'),

      prometheus:
        utils.helmTemplate +
        application.spec.destination.withNamespace('prometheus') +
        application.spec.syncPolicy.withSyncOptionsMixin('ServerSideApply=true') +
        utils.helmTemplate.withSourcesMixin('https://prometheus-community.github.io/helm-charts', 'kube-prometheus-stack', self.prometheus.targetRevision, self.prometheus.valueFiles) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/base/prometheus/values.yaml'),

      'external-secrets':
        utils.helmTemplate +
        application.metadata.withAnnotationsMixin({
          'argocd.argoproj.io/sync-wave': '-10',
        }) +
        application.spec.destination.withNamespace('external-secrets') +
        utils.helmTemplate.withSourcesMixin('https://charts.external-secrets.io', 'external-secrets', self['external-secrets'].targetRevision, self['external-secrets'].valueFiles) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/base/external-secrets/values.yaml'),

      argocd:
        utils.helmTemplate +
        utils.helmTemplate.withTargetRevision(importstr 'envs/management-local/argocd/version.txt') +
        application.metadata.withAnnotationsMixin({
          'argocd.argoproj.io/sync-wave': '-20',
        }) +
        application.spec.destination.withNamespace('argocd') +
        utils.helmTemplate.withSourcesMixin('https://argoproj.github.io/argo-helm', 'argo-cd', self.argocd.targetRevision, self.argocd.valueFiles) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/base/argocd/values.yaml'),

      'metrics-server':
        utils.helmTemplate +
        application.metadata.withAnnotationsMixin({
          'argocd.argoproj.io/sync-wave': '-30',
        }) +
        application.spec.destination.withNamespace('kube-system') +
        utils.helmTemplate.withSourcesMixin('https://kubernetes-sigs.github.io/metrics-server', 'metrics-server', self['metrics-server'].targetRevision, self['metrics-server'].valueFiles) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/base/metrics-server/values.yaml'),

      'app-of-apps':
        utils.appTemplate +
        utils.appTemplate.withEnabled(true) +
        application.spec.source.withRepoURL('https://github.com/irizzante/management-cluster.git') +
        application.spec.source.withTargetRevision('HEAD') +
        application.spec.source.withPath('apps') +
        application.spec.source.plugin.withEnv([
          { name: 'TK_ENV', value: 'default' },
          { name: 'TK_EXTRA_ARGS', value: '' },
        ]),

    },

    projects+: {
      platform:
        project.spec.withDescription('Platform applications') +
        project.spec.withSourceRepos('*') +
        project.spec.withDestinations(
          project.spec.destinations.withNamespace('*') +
          project.spec.destinations.withServer('https://kubernetes.default.svc')
        ) +
        project.spec.withClusterResourceWhitelist([
          { group: '*', kind: '*' },
        ]),
    },

  },

}
