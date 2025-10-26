/*
Copyright © 2025 Utkarsh Srivastava

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"fmt"
	"runtime"

	"github.com/charmbracelet/log"
	"github.com/spf13/cobra"
)

// envNamePrefix is the prefix for all the docker related
// entities (eg. container, image, etc.)
const envNamePrefix string = "devenv2"

var arch string

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "devenv2",
	Short: "devenv2 - CLI to manage a developer environment",
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		log.Info("devenv2", "arch", arch)
	},
}

func Execute() {
	cobra.CheckErr(rootCmd.Execute())
}

func init() {
	cobra.OnInitialize(initConfig)
	rootCmd.PersistentFlags().StringVar(&arch, "arch", runtime.GOARCH, "Specify the architecture for devenv2")
}

func initConfig() {
}

// getEnvName returns the name of the environment based
// on the configured value of `envNamePrefix` and `arch`
func getEnvName() string {
	return fmt.Sprintf("%s-%s", envNamePrefix, arch)
}
