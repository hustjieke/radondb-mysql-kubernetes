/*
Copyright 2021 RadonDB.
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

package utils

// gry:这里能不能改用math.Min(...),像presslabs里面:
// instances := math.Max(math.Min(cpuRounded, math.Floor(float64(innodbBufferPoolSize)/float64(gb))), 1)
// Min returns the smallest int64 that was passed in the arguments.
func Min(a, b int64) int64 {
	if a < b {
		return a
	}
	return b
}

// Max returns the largest int64 that was passed in the arguments.
func Max(a, b int64) int64 {
	if a > b {
		return a
	}
	return b
}
