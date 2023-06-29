{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/apps/lib/variants/prod/nginx/values-prod.yaml',
          '$values/apps/lib/variants/prod/nginx/values-replicas.yaml',
        ],
      },

      prometheus+: {
        valueFiles+: [
          '$values/apps/lib/variants/prod/prometheus/values-replicas.yaml',
        ],
      },

      argocd+: {
        valueFiles+: [
          '$values/apps/lib/variants/prod/argocd/values-prod.yaml',
          '$values/apps/lib/variants/prod/argocd/values-replicas.yaml',
        ],
      },

      'metrics-server'+: {
        valueFiles+: [
          '$values/apps/lib/variants/prod/metrics-server/values-prod.yaml',
          '$values/apps/lib/variants/prod/metrics-server/values-replicas.yaml',
        ],
      },

    },

  },
}
