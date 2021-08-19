module github.com/radondb/radondb-mysql-kubernetes

go 1.16

require (
	github.com/blang/semver v3.5.1+incompatible
	github.com/go-ini/ini v1.62.0
	github.com/go-sql-driver/mysql v1.6.0
	github.com/imdario/mergo v0.3.12
	github.com/onsi/ginkgo v1.16.4
	github.com/onsi/gomega v1.13.0
	github.com/presslabs/controller-util v0.3.0
	github.com/spf13/cobra v1.1.1
	github.com/stretchr/testify v1.7.0
	k8s.io/api v0.21.2
	k8s.io/apimachinery v0.21.2
	k8s.io/client-go v0.21.2
	k8s.io/klog/v2 v2.8.0
	sigs.k8s.io/controller-runtime v0.9.2
)
