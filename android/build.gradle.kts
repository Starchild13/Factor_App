// Top-level build file where you can add configuration options common to all sub-projects/modules.

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Custom build directory configuration for Flutter integration
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    // Ensure the app module is evaluated before other subprojects if needed
    project.evaluationDependsOn(":app")
}

// Clean task to delete the build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

