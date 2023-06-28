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

    },

  },
}
