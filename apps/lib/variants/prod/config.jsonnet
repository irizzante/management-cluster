{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/apps/lib/variants/prod/nginx/values-prod.yaml',
        ],
      },

      prometheus+: {
        valueFiles+: [
          '$values/apps/lib/variants/prod/prometheus/values-prod.yaml',
        ],
      },

      argocd+: {
        valueFiles+: [
          '$values/apps/lib/variants/prod/argocd/values-prod.yaml',
        ],
      },

      'metrics-server'+: {
        valueFiles+: [
          '$values/apps/lib/variants/prod/metrics-server/values-prod.yaml',
        ],
      },

    },

  },
}
