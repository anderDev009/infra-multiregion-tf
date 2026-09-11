#  Multi-Region AWS Lab — Terraform on Floci

<p>
  <img alt="Terraform" src="https://img.shields.io/badge/Terraform-%3E%3D1.5-7B42BC?style=for-the-badge&logo=terraform&logoColor=white">
  <img alt="AWS Provider" src="https://img.shields.io/badge/AWS%20Provider-%7E%3E%206.0-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white">
  <img alt="Floci" src="https://img.shields.io/badge/Floci-AWS%20emulation-2EA043?style=for-the-badge&logo=amazonwebservices&logoColor=white">
  <img alt="Regions" src="https://img.shields.io/badge/Regions-us--east--1%20%7C%20us--west--2-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white">
</p>
<p>
  <img alt="Nginx" src="https://img.shields.io/badge/Nginx-EC2%20workload-009639?style=for-the-badge&logo=nginx&logoColor=white">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22.04%20Jammy-E95420?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Route53" src="https://img.shields.io/badge/Route%2053-latency%20routing-8C4FFF?style=for-the-badge&logo=amazonroute53&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/status-lab%20%2F%20not%20production-red?style=for-the-badge">
</p>

Infraestructura como código que despliega un stack **activo-activo en dos regiones** (`us-east-1` y `us-west-2`), con failover automático vía DNS, corriendo íntegramente contra **Floci** como laboratorio de práctica de Terraform + arquitectura multi-región.

> ⚠️ **Esto NO es AWS real.** Todos los providers apuntan a un endpoint local de [**Floci**](https://floci.io/) (`http://192.168.1.101:4566`) — un emulador de AWS open-source (MIT), *drop-in replacement* de LocalStack, mismo puerto y misma configuración de provider. Es un entorno de laboratorio pensado para practicar patrones de alta disponibilidad sin gastar un centavo en AWS.

---

## 🧱 Stack tecnológico

| Tecnología | Uso en este proyecto |
|---|---|
| ![Terraform](https://cdn.simpleicons.org/terraform/7B42BC) **Terraform** | IaC declarativo, módulos reutilizables, backend remoto S3 |
| ![AWS](https://cdn.simpleicons.org/amazonaws/FF9900) **AWS Provider (`~> 6.0`)** | VPC, ALB, Auto Scaling, Route 53 — emulado por Floci |
| 🟢 **[Floci](https://floci.io/)** | Emulación local de la API de AWS (EC2, ELBv2, Route 53, ASG, S3, IAM, STS) — *drop-in replacement* open-source (MIT) de LocalStack |
| ![Ubuntu](https://cdn.simpleicons.org/ubuntu/E95420) **Ubuntu 22.04 (Jammy)** | AMI base de las instancias EC2 |
| ![Nginx](https://cdn.simpleicons.org/nginx/009639) **Nginx** | Servidor web de prueba, instalado vía `user_data` |
| ![Amazon S3](https://cdn.simpleicons.org/amazons3/569A31) **S3** | Backend remoto de estado de Terraform |

---

## 🏗️ Arquitectura

El diagrama completo está en [`docs/architecture-diagram.html`](docs/architecture-diagram.html) — es un HTML interactivo standalone (zoom, temas claro/oscuro, vistas guiadas), no una imagen estática. Abrilo directo en el navegador.

> 🤖 **Generado con asistencia de IA:** este diagrama fue creado con **Claude (Anthropic)** usando la herramienta **[archify](https://github.com/tt-a1i/archify)**, a partir de la lectura real de los archivos `.tf` del proyecto — no fue dibujado a mano. Fue validado automáticamente (0 cruces de conexiones, 0 errores de composición) antes de entregarse.

### Resumen del flujo

```
                         Route 53 (app.lab.local)
                        latency routing + health check
                              /              \
                    us-east-1 (ALB)      us-west-2 (ALB)
                         |                      |
                    ASG · EC2              ASG · EC2
                 (Ubuntu + Nginx)       (Ubuntu + Nginx)
                    subred privada         subred privada
                         |                      |
                    NAT Gateway            NAT Gateway
                         |                      |
                  Internet Gateway       Internet Gateway
```

### Componentes por región

- **VPC dedicada** (`10.0.0.0/16`) con subredes públicas y privadas en 2 AZs.
- **Internet Gateway + NAT Gateway**: las instancias privadas salen a internet solo a través del NAT.
- **Application Load Balancer**: expuesto en las subredes públicas, único punto de entrada HTTP.
- **Auto Scaling Group** (2–4 instancias EC2 Ubuntu + Nginx) en subredes privadas.
- **Security Groups en cadena**: `sg-alb` (80/443 abierto a internet) → `sg-instance` (80 solo desde `sg-alb`, nunca expuesto directo).

### Capa global

- **Route 53** con **latency-based routing** entre ambas regiones.
- **Health checks HTTP** por región (`failure_threshold = 3`) que sacan de servicio automáticamente la región caída.
- **Backend de estado remoto** en un bucket S3 (`infra-multiregion`), también servido por Floci.

---

## 📂 Estructura del repo

```
.
├── main.tf                    # orquesta ambas regiones + módulo DNS
├── providers.tf                # providers aws.primary / aws.secondary → Floci
├── backend.tf                  # backend S3 remoto (Floci)
├── variables.tf
├── docs/
│   ├── architecture-diagram.html   # diagrama interactivo (generado con IA)
│   └── architecture.diagram.json   # especificación fuente del diagrama
└── modules/
    ├── multiregion-stack/      # VPC, subredes, IGW/NAT, ALB, ASG, security groups
    └── dns/                    # zona Route 53, records con latency routing, health checks
```

---

## 🚀 Uso

Requiere Floci corriendo y accesible en `192.168.1.101:4566`.

```bash
terraform init
terraform plan
terraform apply
```

## 📝 Notas

- `avaliability_zones` está mal escrito a propósito de origen (typo heredado en variables/módulos) — se mantiene así para no romper referencias internas del módulo.
- El backend S3 usa credenciales dummy (`test`/`test`) porque Floci no valida credenciales reales.
