local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.5/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;

{

  _config+:: {

    applications+: {

      nginx: {
        enabled: true,
        annotations: {
          'argocd.argoproj.io/sync-wave': '-10',
        },
        finalizers: [
          'resources - finalizer.argocd.argoproj.io',
        ],
        project: 'platform',
        destination: {
          namespace: 'nginx',
        },
        syncPolicy: {
          allowEmpty: true,
          selfHeal: true,
          prune: true,
        },
        syncOptions: [
          'CreateNamespace=true',
          'PruneLast=true',
        ],
        valuesRepo: {
          repoURL: 'https://github.com/irizzante/management-cluster.git',
          ref: 'value',
          targetRevision: 'main',
        },
        valueFiles: [
          '$values/test/tanka/lib/base/nginx/values.yaml',
        ],
        targetRevision: '',
        sources: [
          self.valuesRepo,
          (
            application.spec.source.withRepoURL('https://kubernetes.github.io/ingress-nginx') +
            application.spec.source.withTargetRevision(self.targetRevision) +
            application.spec.source.withChart('ingress-nginx') +
            application.spec.source.helm.withValueFiles(self.valueFiles)
          ).spec.source,
        ],
      },

      prometheus: {
        enabled: true,
        annotations: {
        },
        finalizers: [
          'resources - finalizer.argocd.argoproj.io',
        ],
        project: 'platform',
        destination: {
          namespace: 'prometheus',
        },
        syncPolicy: {
          allowEmpty: true,
          selfHeal: true,
          prune: true,
        },
        syncOptions: [
          'CreateNamespace=true',
          'PruneLast=true',
          'ServerSideApply=true',
        ],
        valuesRepo: {
          repoURL: 'https://github.com/irizzante/management-cluster.git',
          ref: 'value',
          targetRevision: 'main',
        },
        valueFiles: [
          '$values/test/tanka/lib/base/prometheus/values.yaml',
        ],
        targetRevision: '',
        sources: [
          self.valuesRepo,
          (
            application.spec.source.withRepoURL('https://prometheus-community.github.io/helm-charts') +
            application.spec.source.withTargetRevision(self.targetRevision) +
            application.spec.source.withChart('kube-prometheus-stack') +
            application.spec.source.helm.withValueFiles(self.valueFiles)
          ).spec.source,
        ],
      },
    },

    projects+: {

    },

  },

}
