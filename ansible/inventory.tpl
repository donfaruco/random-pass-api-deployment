[api_servers]
%{ for ip in all_ips ~}
${ip}
%{ endfor ~}

