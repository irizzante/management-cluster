local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.5/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;

{

  _config+:: {

    applications+: {

      local helmAppTemplate = {
        enabled: true,
        annotations: {
        },
        finalizers: [
          'resources-finalizer.argocd.argoproj.io',
        ],
        project: 'platform',
        destination: {
          namespace: '',
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
          ref: 'values',
          targetRevision: 'main',
        },
        valueFiles: [
        ],
        targetRevision: '',
        sources: [
          self.valuesRepo,
        ],
      },

      nginx: {
        enabled: true,
        annotations: {
          'argocd.argoproj.io/sync-wave': '-10',
        },
        finalizers: [
          'resources-finalizer.argocd.argoproj.io',
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
          ref: 'values',
          targetRevision: 'main',
        },
        valueFiles: [
          '$values/apps/lib/base/nginx/values.yaml',
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
          'resources-finalizer.argocd.argoproj.io',
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
          ref: 'values',
          targetRevision: 'main',
        },
        valueFiles: [
          '$values/apps/lib/base/prometheus/values.yaml',
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

      'external-secrets': {
        enabled: true,
        annotations: {
          'argocd.argoproj.io/sync-wave': '-10',
        },
        finalizers: [
          'resources-finalizer.argocd.argoproj.io',
        ],
        project: 'platform',
        destination: {
          namespace: 'external-secrets',
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
          ref: 'values',
          targetRevision: 'main',
        },
        valueFiles: [
          '$values/apps/lib/base/external-secrets/values.yaml',
        ],
        targetRevision: '',
        sources: [
          self.valuesRepo,
          (
            application.spec.source.withRepoURL('https://charts.external-secrets.io') +
            application.spec.source.withTargetRevision(self.targetRevision) +
            application.spec.source.withChart('external-secrets') +
            application.spec.source.helm.withValueFiles(self.valueFiles)
          ).spec.source,
        ],
      },

      'cluster-store': {
        enabled: true,
        annotations: {
        },
        finalizers: [
          'resources-finalizer.argocd.argoproj.io',
        ],
        project: 'platform',
        destination: {
          namespace: 'external-secrets',
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
          ref: 'values',
          targetRevision: 'main',
        },
        targetRevision: 'HEAD',
        source: application.spec.source.withRepoURL('https://github.com/irizzante/management-cluster.git') +
                application.spec.source.withTargetRevision(self.targetRevision) +
                application.spec.source.withPath('apps/lib/base/cluster-store'),
      },

      argocd: helmAppTemplate {
        annotations: {
          'argocd.argoproj.io/sync-wave': '-20',
        },
        destination: {
          namespace: 'argocd',
        },
        valueFiles+: [
          '$values/apps/lib/base/argocd/values.yaml',
        ],
        sources+: [
          (
            application.spec.source.withRepoURL('https://argoproj.github.io/argo-helm') +
            application.spec.source.withTargetRevision(self.targetRevision) +
            application.spec.source.withChart('argo-cd') +
            application.spec.source.helm.withValueFiles(self.valueFiles)
          ).spec.source,
        ],
      },

      'metrics-server': helmAppTemplate {
        annotations: {
          'argocd.argoproj.io/sync-wave': '-30',
        },
        destination: {
          namespace: 'kube-system',
        },
        valueFiles+: [
          '$values/apps/lib/base/metrics-server/values.yaml',
        ],
        sources+: [
          (
            application.spec.source.withRepoURL('https://kubernetes-sigs.github.io/metrics-server') +
            application.spec.source.withTargetRevision(self.targetRevision) +
            application.spec.source.withChart('metrics-server') +
            application.spec.source.helm.withValueFiles(self.valueFiles)
          ).spec.source,
        ],
      },

    },

    projects+: {

    },

  },

}
