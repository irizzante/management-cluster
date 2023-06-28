{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/apps/lib/variants/local/nginx/values-local.yaml',
        ],
      },

    },

  },
}
