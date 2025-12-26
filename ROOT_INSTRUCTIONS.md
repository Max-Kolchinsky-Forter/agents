<INSTRUCTIONS>
This file contains instructions for creating an agentic coding framework. This file CAN and SHOULD be edited as needed, as part of a prompt engineering process, to create a prompt that will generate the best results.

If you are ever unsure what exactly you need to do or what your next steps are, always ask.
</INSTRUCTIONS>

I am a software developer looking to upgrade the way I work with coding agents. I have compiled a list of frameworks, blog posts, instruction files and various agent modes in the [source material file](./SOURCE_MATERIAL.md).

I develop predominantly in Python, as well as TypeScript (when developing GUI apps). I mostly work with AWS, K8s, Grafana, GitHub Actions, JSM, Asana, as well as other tech.
I work on a Mac. My preferred shell is zsh. My IDE of choice is VSCode, with Copilot as my preferred AI coding tool. (If throughout your research you find that there's a strong incentive for me to switch to Cursor or Claude Code, LMK; my preference, however, is to stick with Copilot)

Things I care about during coding:

1. Generating correct, simple, easy-to-maintain code
2. NOT generating unnecessary slop/fluff
3. Adhering to consistent coding best practices (including repo-specific directives)
4. Being mindful of token usage/cost (ie not overloading the context window; choosing the right model for the job, etc)
5. Preferring being right on the first try, over quick responses
6. Verifying correctness (via tests, linting, typing, etc), over quick/obvious solutions
7. Having a set-and-forget setup that I can easily use with multiple repos without having to work hard for each new repo
8. Having an easy-to-maintain agentic coding framework that I can modify and improve over time

Ultimately, I will want to generate:

1. A set of global Copilot instruction files I can put in `~/Library/Application Support/Code/User/prompts/`. These will determine how my day to day interactions with Copilot look.
2. A set of agent modes that I can call on demand, to assist me in specific tasks (eg Tech Debt Mode, Architecture Review Mode, Ideation Mode, etc)
3. A clear framework that I can easily modify and improve over time, with an ability to quickly provide feedback to it
4. A rundown of the current prevailing wisdom in the field, to guide my thinking around this topic.
5. Where applicable, download the frameworks, instructions files, prompts and agent modes directly to this repo. Where applicable, summarize the various frameworks, modes, blog posts, and only keep the summaries in the repo.

---

Go over the [source material file](./SOURCE_MATERIAL.md), and read DEEPLY and FULLY the relevant source material to be able to achieve the above goals. Use `gh` freely to download files from GitHub, and feel free to keep them in the repo in the [docs](./docs) folder, if it makes sense to keep them there as is.
DO NOT rely on summaries and compaction at this point; read the files FULLY, follow up on links where applicable, and achieve perfect understanding of the material.
The most important frameworks to start with are the [Instruction Files](./SOURCE_MATERIAL.md#instruction-files) section. Pay special attention to the `humanlayer` and to the Cursor RIPER frameworks, and understand them FULLY.

Put instruction files in the [instructions](./instructions/) folder.
Put prompts in the [prompts](./prompts/) folder.
Put all other docs in the [docs](./docs) folder.
