# Setting Up Ollama Cloud API Key

This guide explains how to set up the **Ollama Cloud API key** for accessing ollama cloud models through Ollama’s cloud endpoint.

---

## 1. Go to [Ollama.com](https://ollama.com)

1. Open your browser and visit [https://ollama.com](https://ollama.com).  
2. **Sign up** using your email address.  
   - If you already have an account, simply **sign in** instead.

---

## 2. Download and Install Ollama

1. Click **Download** on the Ollama homepage and install the version for your operating system (macOS, Windows, or Linux).  
2. Even if you already have Ollama installed, **we recommend reinstalling** it — Ollama Cloud is supported only in the **latest versions** of Ollama.  
   - Minimum version that supports Ollama Cloud: **v0.5.0 (September 2025)**.  
3. On macOS or Linux, if you already have an instance running, stop it before reinstalling:
   ```bash
   ollama stop
   ```

## 3. Sign In to Ollama Cloud

After installation, sign in to your Ollama account from your terminal:
```bash
ollama signin
```
Follow the terminal instructions 

## 4. Retrieve Your API Key
After signing in, go to your Ollama Account Settings in the browser.
1. Scroll down to the API Keys section.
2. Click Generate new API key.
3. Copy the generated key

## 5. Set the API Key as an Environment Variable

Set the API key so your applications can access Ollama Cloud.
```bash
export OLLAMA_API_KEY="your_key"
```
To make it permanent, add the line above to your shell config file (~/.bashrc or ~/.zshrc).




