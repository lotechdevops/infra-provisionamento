locals {
  eks_addons_config = {
    vpc-cni = {
      version = "v1.19.3-eksbuild.1"
    }
    coredns = {
      version = "v1.11.4-eksbuild.2"
    }
    kube-proxy = {
      version = "v1.32.0-eksbuild.2"
    }
    metrics-server = {
      version = "v0.7.2-eksbuild.2"
    }
    kube-state-metrics = {
      version = "v2.15.0-eksbuild.3"
    }
    aws-ebs-csi-driver = {
      version = "v1.41.0-eksbuild.1"
    }
    aws-efs-csi-driver = {
      version = "v2.1.7-eksbuild.1"
    }
  }
}
