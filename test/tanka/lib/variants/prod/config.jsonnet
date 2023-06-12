{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/prod/nginx/values-prod.yaml',
          '$values/test/tanka/lib/variants/prod/nginx/values-settings.yaml',
        ],
      },

      prometheus+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/prod/prometheus/values-prod.yaml',
          '$values/test/tanka/lib/variants/prod/prometheus/values-settings.yaml',
        ],
      },

    },

  },
}
