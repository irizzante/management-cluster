{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [
    gum
    gh
    kind
    kubectl
    tanka
    jsonnet
    jsonnet-bundler
    yq-go
    jq
    awscli2
    upbound
    crossplane-cli
  ];

  shellHook = ''
  '';
}