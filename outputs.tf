output "cluster_endpoint" {
  value = aws_docdb_cluster.docdb.endpoint
}

output "reader_endpoint" {
  value = aws_docdb_cluster.docdb.reader_endpoint
}

output "cluster_identifier" {
  value = aws_docdb_cluster.docdb.id
}

output "docdb_sg_id" {
  value = aws_security_group.docdb.*.id
}
