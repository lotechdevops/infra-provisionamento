output "sg_master_id" {
  value = aws_security_group.k8s_sg_master.id
}

output "sg_nodes_id" {
  value = aws_security_group.k8s_sg_nodes.id
}
