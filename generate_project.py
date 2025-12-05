import os
import uuid
import json

PROJECT_NAME = "FinFlow"
BUNDLE_ID = "com.leonard1220.FinFlow"
ROOT_DIR = "FinFlow"

# PBXProj template parts
def generate_id():
    return str(uuid.uuid4()).replace("-", "").upper()[:24]

def get_file_type(filename):
    if filename.endswith(".swift"):
        return "sourcecode.swift"
    elif filename.endswith(".xcassets"):
        return "folder.assetcatalog"
    elif filename.endswith(".plist"):
        return "text.plist.xml"
    return "text"

def scan_files(root_dir):
    files = []
    for root, dirs, filenames in os.walk(root_dir):
        if ".xcodeproj" in root:
            continue
            
        # Add directories as groups? 
        # For simplicity in this script, we'll flatten the file structure in the project view 
        # OR better: recreate the group hierarchy.
        
        for f in filenames:
            if f in [".DS_Store", "project.pbxproj", "contents.xcworkspacedata"]:
                continue
            path = os.path.join(root, f)
            rel_path = os.path.relpath(path, root_dir)
            files.append(rel_path)
    
    # Also include top level folders (Assets.xcassets is a folder but treated as file)
    for root, dirs, filenames in os.walk(root_dir):
        if ".xcodeproj" in root:
            continue
        for d in dirs:
            if d.endswith(".xcassets"):
                path = os.path.join(root, d)
                rel_path = os.path.relpath(path, root_dir)
                files.append(rel_path)
                
    return sorted(list(set(files))) # dedupe

def create_pbxproj(files):
    objects = {}
    
    # IDs
    main_group_id = generate_id()
    project_id = generate_id()
    target_id = generate_id()
    config_list_id = generate_id()
    debug_config_id = generate_id()
    release_config_id = generate_id()
    native_config_list_id = generate_id()
    native_debug_id = generate_id()
    native_release_id = generate_id()
    sources_phase_id = generate_id()
    resources_phase_id = generate_id()
    products_group_id = generate_id()
    product_app_id = generate_id()
    
    # Lists
    file_refs = []
    build_files = []
    main_group_children = []
    
    # Helper to create file ref
    def add_file(path):
        file_id = generate_id()
        file_type = get_file_type(path)
        
        # PBXFileReference
        objects[file_id] = {
            "isa": "PBXFileReference",
            "path": path.replace("\\", "/"), # Ensure forward slashes
            "sourceTree": "<group>",
            "lastKnownFileType": file_type
        }
        
        # Add to Main Group
        main_group_children.append(file_id)
        
        # Build Phase Logic
        if path.endswith(".swift"):
            build_file_id = generate_id()
            objects[build_file_id] = {
                "isa": "PBXBuildFile",
                "fileRef": file_id
            }
            build_files.append({"id": build_file_id, "phase": "sources"})
            
        elif path.endswith(".xcassets"):
            build_file_id = generate_id()
            objects[build_file_id] = {
                "isa": "PBXBuildFile",
                "fileRef": file_id
            }
            build_files.append({"id": build_file_id, "phase": "resources"})
            
        # Info.plist is referenced but not in build phase (configured in build settings)
        
    for f in files:
        if "Assets.xcassets" in f and f != "Assets.xcassets": continue # Skip content of xcassets
        add_file(f)

    # Compile Sources Phase
    sources = [bf["id"] for bf in build_files if bf["phase"] == "sources"]
    objects[sources_phase_id] = {
        "isa": "PBXSourcesBuildPhase",
        "buildActionMask": "2147483647",
        "files": sources,
        "runOnlyForDeploymentPostprocessing": "0"
    }

    # Resources Phase
    resources = [bf["id"] for bf in build_files if bf["phase"] == "resources"]
    objects[resources_phase_id] = {
        "isa": "PBXResourcesBuildPhase",
        "buildActionMask": "2147483647",
        "files": resources,
        "runOnlyForDeploymentPostprocessing": "0"
    }

    # Groups
    objects[main_group_id] = {
        "isa": "PBXGroup",
        "children": main_group_children + [products_group_id],
        "sourceTree": "<group>"
    }
    
    objects[products_group_id] = {
        "isa": "PBXGroup",
        "children": [product_app_id],
        "name": "Products",
        "sourceTree": "<group>"
    }

    # Product
    objects[product_app_id] = {
        "isa": "PBXFileReference",
        "explicitFileType": "wrapper.application",
        "includeInIndex": "0",
        "path": f"{PROJECT_NAME}.app",
        "sourceTree": "BUILT_PRODUCTS_DIR"
    }

    # Configurations
    objects[debug_config_id] = {
        "isa": "XCBuildConfiguration",
        "buildSettings": {
            "ALWAYS_SEARCH_USER_PATHS": "NO",
            "CLANG_ENABLE_MODULES": "YES",
            "CLANG_ENABLE_OBJC_ARC": "YES",
            "CODE_SIGN_STYLE": "Automatic",
            "COPY_PHASE_STRIP": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf",
            "ENABLE_STRICT_OBJC_MSGSEND": "YES",
            "GCC_DYNAMIC_NO_PIC": "NO",
            "GCC_OPTIMIZATION_LEVEL": "0",
            "GCC_PREPROCESSOR_DEFINITIONS": ["DEBUG=1", "$(inherited)"],
            "GCC_SYMBOLS_PRIVATE_EXTERN": "NO",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "MTL_ENABLE_DEBUG_INFO": "INCLUDE_SOURCE",
            "MTL_FAST_MATH": "YES",
            "ONLY_ACTIVE_ARCH": "YES",
            "SDKROOT": "iphoneos",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "SWIFT_VERSION": "5.0"
        },
        "name": "Debug"
    }
    
    objects[release_config_id] = {
        "isa": "XCBuildConfiguration",
        "buildSettings": {
            "ALWAYS_SEARCH_USER_PATHS": "NO",
            "CLANG_ENABLE_MODULES": "YES",
            "CLANG_ENABLE_OBJC_ARC": "YES",
            "CODE_SIGN_STYLE": "Automatic",
            "COPY_PHASE_STRIP": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "ENABLE_NS_ASSERTIONS": "NO",
            "ENABLE_STRICT_OBJC_MSGSEND": "YES",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "MTL_ENABLE_DEBUG_INFO": "NO",
            "MTL_FAST_MATH": "YES",
            "SDKROOT": "iphoneos",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-O",
            "SWIFT_VERSION": "5.0",
            "VALIDATE_PRODUCT": "YES"
        },
        "name": "Release"
    }
    
    objects[config_list_id] = {
        "isa": "XCConfigurationList",
        "buildConfigurations": [debug_config_id, release_config_id],
        "defaultConfigurationIsVisible": "0",
        "defaultConfigurationName": "Release"
    }
    
    # Native Target Config
    objects[native_debug_id] = {
        "isa": "XCBuildConfiguration",
        "buildSettings": {
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
            "CODE_SIGN_STYLE": "Automatic",
            "CURRENT_PROJECT_VERSION": "1",
            "DEVELOPMENT_TEAM": "", 
            "GENERATE_INFOPLIST_FILE": "NO",
            "INFOPLIST_FILE": "Info.plist",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
            "MARKETING_VERSION": "1.0",
            "PRODUCT_BUNDLE_IDENTIFIER": BUNDLE_ID,
            "PRODUCT_NAME": "$(TARGET_NAME)",
            "SWIFT_EMIT_LOC_STRINGS": "YES",
            "SWIFT_VERSION": "5.0",
            "TARGETED_DEVICE_FAMILY": "1,2"
        },
        "name": "Debug"
    }
    
    objects[native_release_id] = {
        "isa": "XCBuildConfiguration",
        "buildSettings": {
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
            "CODE_SIGN_STYLE": "Automatic",
            "CURRENT_PROJECT_VERSION": "1",
            "DEVELOPMENT_TEAM": "", 
            "GENERATE_INFOPLIST_FILE": "NO",
            "INFOPLIST_FILE": "Info.plist",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
            "MARKETING_VERSION": "1.0",
            "PRODUCT_BUNDLE_IDENTIFIER": BUNDLE_ID,
            "PRODUCT_NAME": "$(TARGET_NAME)",
            "SWIFT_EMIT_LOC_STRINGS": "YES",
            "SWIFT_VERSION": "5.0",
            "TARGETED_DEVICE_FAMILY": "1,2"
        },
        "name": "Release"
    }

    objects[native_config_list_id] = {
        "isa": "XCConfigurationList",
        "buildConfigurations": [native_debug_id, native_release_id],
        "defaultConfigurationIsVisible": "0",
        "defaultConfigurationName": "Release"
    }

    # Native Target
    objects[target_id] = {
        "isa": "PBXNativeTarget",
        "buildConfigurationList": native_config_list_id,
        "buildPhases": [sources_phase_id, resources_phase_id],
        "buildRules": [],
        "dependencies": [],
        "name": PROJECT_NAME,
        "productName": PROJECT_NAME,
        "productReference": product_app_id,
        "productType": "com.apple.product-type.application"
    }

    # Project
    objects[project_id] = {
        "isa": "PBXProject",
        "attributes": {
            "BuildIndependentTargetsInParallel": "1",
            "LastSwiftUpdateCheck": "1420",
            "LastUpgradeCheck": "1420",
            "TargetAttributes": {
                target_id: {
                    "CreatedOnToolsVersion": "14.2"
                }
            }
        },
        "buildConfigurationList": config_list_id,
        "compatibilityVersion": "Xcode 14.0",
        "developmentRegion": "en",
        "hasScannedForEncodings": "0",
        "knownRegions": ["en", "Base"],
        "mainGroup": main_group_id,
        "productRefGroup": products_group_id,
        "projectDirPath": "",
        "projectRoot": "",
        "targets": [target_id]
    }

    # Serialize
    
    # Custom Old-School PList formatting
    def format_value(v):
        if isinstance(v, list):
            items = ",\n\t\t\t\t".join([format_value(x) for x in v])
            return f"(\n\t\t\t\t{items}\n\t\t\t)"
        return f'{v}' if not isinstance(v, str) or v.isalnum() else f'"{v}"'

    content = "// !$*UTF8*$!\n{\n"
    content += "\tarchiveVersion = 1;\n"
    content += "\tclasses = {\n\t};\n"
    content += "\tobjectVersion = 55;\n"
    content += "\tobjects = {\n"

    for oid, obj in objects.items():
        content += f"\n\t\t{oid} = {{\n"
        for k, v in obj.items():
            val_str = ""
            if isinstance(v, list):
                val_str = "(\n" + "".join([f"\t\t\t\t{x},\n" for x in v]) + "\t\t\t)"
            elif isinstance(v, dict):
                 val_str = "{\n" + "".join([f"\t\t\t\t{dk} = {dv};\n" for dk, dv in v.items()]) + "\t\t\t}"
            else:
                val_str = f'"{v}"' if not str(v).isalnum() and "." in str(v) else str(v) 
                if k in ["buildSettings", "attributes"]: # Special handling
                    pass 
                elif str(v).isalnum(): val_str = str(v)
                else: val_str = f'"{v}"'
            
            content += f"\t\t\t{k} = {val_str};\n"
        content += "\t\t};\n"

    content += "\t};\n"
    content += f"\trootObject = {project_id};\n"
    content += "}"
    
    return content

files = scan_files(ROOT_DIR)
print(f"Found {len(files)} files to add.")
for f in files: print(f" - {f}")

content = create_pbxproj(files)
with open(f"{ROOT_DIR}/{PROJECT_NAME}.xcodeproj/project.pbxproj", "w") as f:
    f.write(content)

print("project.pbxproj generated successfully.")
