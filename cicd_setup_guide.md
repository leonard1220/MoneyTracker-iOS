# iOS GitHub Actions CI/CD 设置指南

这个指南将一步一步教你如何配置 GitHub Actions，以便自动打包你的 iOS 应用生成 `.ipa` 安装包。

## 第一步：准备签名文件 (最关键的一步)

苹果要求 iOS 应用必须经过"签名"才能安装。我们需要两个文件：

1.  **开发证书 (Development Certificate)**: 以 `.p12` 结尾的文件。证明开发者的身份。
2.  **描述文件 (Provisioning Profile)**: 以 `.mobileprovision` 结尾的文件。包含你的设备 ID (UDID) 和 App ID。

### 如果你有 Mac 电脑 (或借用朋友的 Mac)
1.  打开 **钥匙串访问 (Keychain Access)**。
2.  找到你的 **Apple Development** 证书。
3.  如果不包含私钥（小三角折叠），则无法导出。必须找到带私钥的证书。
4.  右键点击证书，选择 **导出 (Export)**。
5.  保存为 `.p12` 格式，并设置一个密码 (例如 `123456`)。**记住这个密码！**
6.  登录 [Apple Developer 网站](https://developer.apple.com/) 下载对应的 Provisioning Profile (`.mobileprovision`)。

### 如果你只有 Windows
这是最难的部分。通常你需要 Mac 来生成 CSR (证书签名请求)。
如果你没有 `.p12` 文件，你可能需要使用 OpenSSL 在 Windows 上生成 CSR，然后去 Apple 开发者网站申请证书，再合成 `.p12`。这比较复杂。
*建议：找一个有 Mac 的朋友帮你导出 `.p12` 和下载 `.mobileprovision`。*

---

## 第二步：获取文件的 Base64 编码

GitHub 不能直接上传文件作为密钥，我们需要把它们转换成一串文本 (Base64 编码)。

### 在 Windows (使用 PowerShell)
打开 PowerShell，运行以下命令 (替换文件路径)：

```powershell
# 1. 转换证书 (.p12)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\路径\到\你的证书.p12")) | Set-Clipboard
# 执行后，Base64 字符串已经在你的剪贴板里了。去 GitHub 粘贴 (见第三步)。

# 2. 转换描述文件 (.mobileprovision)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\路径\到\你的描述文件.mobileprovision")) | Set-Clipboard
```

---

## 第三步：配置 GitHub Secrets

1.  在浏览器打开你的 GitHub 仓库页面。
2.  点击顶部的 **Settings (设置)** 分页。
3.  在左侧侧边栏，点击 **Secrets and variables** -> **Actions**。
4.  点击右上角的绿色按钮 **New repository secret**。
5.  你需要添加以下 3 个密钥：

| Name (密钥名称) | Secret (密钥内容) |
| :--- | :--- |
| `BUILD_CERTIFICATE_BASE64` | 粘贴刚才转换的 `.p12` 文件的 Base64 字符串 |
| `P12_PASSWORD` | 填写你导出 `.p12` 时设置的密码 |
| `PROVISIONING_PROFILE_BASE64` | 粘贴刚才转换的 `.mobileprovision` 文件的 Base64 字符串 |

---

## 第四步：触发构建

1.  你在本地的代码已经包含了我生成的 `.github/workflows/ios-build.yml` 文件。
2.  只需要提交并推送到 GitHub：
    ```bash
    git add .
    git commit -m "Add CI/CD pipeline"
    git push
    ```
3.  推送成功后，去 GitHub 仓库点击 **Actions** 分页。
4.  你会看到一个名为 "iOS Build" 的工作流正在运行。

---

## 第五步：下载 IPA 安装包

1.  等待 Actions 运行完成 (通常需要 5-10 分钟)。
2.  如果显示绿色 ✅，点击进入该次运行详情。
3.  在页面底部的 **Artifacts** 区域，你会看到 `iOS-IPA`。
4.  点击下载，解压后就是 `.ipa` 文件！

---

## 如何安装 IPA?

由于你是 Windows 用户，你可以使用以下工具将 `.ipa` 安装到你的 iPhone/iPad：
- **爱思助手 (i4Tools)**
- **Sideloadly**
- **AltStore**
