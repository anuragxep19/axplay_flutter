allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Force Java compatibility to 17
    plugins.withType<JavaPlugin>().configureEach {
        extensions.configure<JavaPluginExtension> {
            sourceCompatibility = JavaVersion.VERSION_17
            targetCompatibility = JavaVersion.VERSION_17
        }
    }

    // Force Kotlin compatibility to JVM 17
    plugins.withType<org.jetbrains.kotlin.gradle.plugin.KotlinBasePlugin>().configureEach {
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "17"
            }
        }
    }
      afterEvaluate {
        extensions.findByName("android")?.let { ext ->
            val androidExtension = ext as com.android.build.gradle.BaseExtension
            androidExtension.compileOptions.sourceCompatibility = JavaVersion.VERSION_17
            androidExtension.compileOptions.targetCompatibility = JavaVersion.VERSION_17
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
