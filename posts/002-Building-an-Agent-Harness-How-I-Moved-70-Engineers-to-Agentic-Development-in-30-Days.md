# Building an Agent Harness: How I Moved 70 Engineers to Agentic Development in 30 Days

---

> "Making strength productive is the unique purpose of organization. It cannot, of course, overcome the weaknesses with which each of us is abundantly endowed. But it can make them irrelevant."
>
> Peter Drucker, *The Effective Executive*

---

Drucker was talking about people. But the same principle applies to codebases.

Every codebase has strengths: years of domain logic, battle-tested patterns, hard-won architectural decisions. It also has weaknesses: tribal knowledge locked in a few people's heads, conventions that exist only as oral tradition, patterns that new engineers violate because nobody wrote them down.

An agent harness makes your codebase's strengths productive for AI. It encodes the rules, patterns, and institutional knowledge that your best engineers carry implicitly, and makes that knowledge available to every engineer through their AI coding tools. Without it, AI tools generate plausible-looking code that violates your platform's conventions. With it, they generate code that belongs in your repo.

This post is about how I took a 70-person mobile engineering organization from "a few people experimenting with Claude Code" to "the entire org contributing to an agent harness" in about 30 days.

---

## What Is an Agent Harness?

An agent harness is the collection of rules, skills, and tool configurations that teach an AI coding agent how to work *in your specific codebase*.

For us, this lives in the `.claude/` directory of our iOS and Android repositories:

| Component | What It Does | Example |
|-----------|-------------|---------|
| **CLAUDE.md** | Top-level instructions for the agent: project overview, architecture, conventions | "This is a Swift/UIKit app using MVVM-C. All new screens must use the Coordinator pattern." |
| **Rules** | Specific guardrails for code generation: memory management, threading, platform patterns | "Never retain self strongly in closures passed to async APIs. Always use `[weak self]`." |
| **Skills** | Reusable workflows the agent can execute end-to-end | "Given a User Story with Figma details, generate a complete screen with ViewModel, View, Coordinator, and unit tests." |
| **MCP Servers** | Connections to external tools (design systems, CI, internal APIs) | Connect to our component library so the agent knows which UI components exist and how to use them |

If your codebase is a factory, the agent harness is the training manual you hand to every new worker on day one. Except this worker reads the entire manual in seconds and follows every instruction literally.

The harness encodes things like: how we handle memory management in our hybrid WebView architecture, how to interpret our internal metadata format when building UI, which patterns to use for navigation and state management, and how our design system components map to code. These are things a senior engineer "just knows." The agent harness makes that knowledge executable.

---

## Phase 1: The Pioneers

Every technology adoption curve starts the same way. A handful of people who are curious, technically fearless, and willing to tolerate rough edges.

We had four.

Four engineers, out of 70, who took the liberty of adding Claude Code to our mobile app repos on their own. They weren't asked to. Nobody mandated it. They saw an opportunity, set it up, and started contributing rules to the `.claude/` directories.

### What the Pioneers Did

They started with pain points they personally felt every day:

| Pioneer Contribution | Problem It Solved |
|---------------------|-------------------|
| Memory management rules for our WebView layer | New engineers kept introducing retain cycles in the hybrid rendering pipeline |
| Metadata interpretation patterns | Our internal format has quirks that aren't documented anywhere outside of one engineer's head |
| Platform-specific UI patterns | Code review kept catching the same SwiftUI vs. UIKit anti-patterns |
| Build configuration rules | Agents kept generating code that compiled locally but broke CI |

Notice what these have in common. They're all things the pioneers were already explaining to people in code review, in Slack, in onboarding docs nobody reads. They took that knowledge and encoded it as machine-readable rules.

### What I Did (and Didn't Do) as a Leader

Here's what I got right: I left them alone. No process. No templates. No review board. Four engineers experimenting in their repos. That's it.

Here's what I did do: I watched the commit logs. I read their rules. I started using Claude Code myself with those rules active and saw the difference. A prompt that previously generated "close but wrong" code now generated code that matched our conventions.

That observation was the turning point. I realized this wasn't a tooling experiment. It was an organizational knowledge problem being solved in a new way.

Drucker wrote that the effective executive looks for situations where their strengths can produce significant results. The pioneers had found one: the gap between "what our best engineers know" and "what our codebase communicates" was the exact gap that an agent harness could close.

### Lessons from Phase 1

| Lesson | Why It Matters |
|--------|---------------|
| Let pioneers emerge organically | Mandating experimentation kills it. The best early adopters are self-selected. |
| Don't over-process early contributions | Version 1 of any rule will be imperfect. That's fine. Iterate later. |
| The leader's job is to *recognize* the pattern, not create it | I didn't invent the agent harness. I recognized what 4 people were building and saw the org-wide potential. |

---

## Phase 2: Operationalize

Phase 1 proved the concept. Phase 2 was about turning 4 pioneers into 70 contributors. This is where most AI adoption initiatives die. The gap between "a few enthusiasts" and "the whole team" is a leadership problem, not a technology problem.

### Step 1: Share the Vision

I carved out time in our all-hands to explain what the agent harness was, why it mattered, and where we were headed. Not a sales pitch for AI. A concrete story:

*"Four engineers have been writing rules that teach Claude Code how our codebase works. When those rules are active, the agent generates code that follows our conventions instead of generic patterns. We're going to scale this across every repo and every team. Your job isn't just to write features anymore. It's to teach the agent how to write features the way we write them."*

That last line landed. It reframed the work from "optional AI experiment" to "part of your engineering responsibility."

### Step 2: SME Demos

Vision without proof is just a speech. I identified subject matter experts across iOS, Android, and QE and asked them to run live demos for their teams.

These weren't slide decks. They were live coding sessions using real artifacts from our backlog. Three demos in particular changed the conversation:

| Demo | What the SME Showed | Why It Hit |
|------|---------------------|------------|
| **Story to Code** | Took an actual User Story with Figma mockups, requirements, and acceptance criteria. Fed it to a Claude Code skill. Out came a working implementation: ViewModel, View, Coordinator, unit tests. | Engineers saw a story they'd normally spend 2-3 days on get scaffolded in minutes. The code followed *our* patterns, not generic ones. |
| **Defect Troubleshooting** | Took a real defect report from our backlog. The skill analyzed it and generated multiple fix plans, each with tradeoffs, for an engineer to review and approve. | This wasn't "AI writes the fix." It was "AI gives you three options and you pick the best one." That distinction matters for trust. |
| **Memory Leak Detection Rules** | Showed rules that catch memory leak patterns based on actual bugs we've shipped. Ran Claude Code against a PR with a known retain cycle and watched it flag the issue before the PR was even reviewed. | Every engineer in the room had personally debugged one of these leaks. Seeing the agent catch it automatically was the "aha" moment. |

The format mattered as much as the content:

| Demo Format | Why It Worked |
|-------------|---------------|
| Live, not recorded | Engineers trust what they see in real-time. Recordings feel like marketing. |
| Real artifacts from the actual backlog | "This is the story you were going to pick up next sprint" hits differently than a toy example. |
| SMEs from their own team, not me | A peer showing you something is 10x more persuasive than your Director telling you about it. |
| Warts included | When the skill produced code that needed adjustments, the SME showed how to fix the rule. That was the point: *the agent learns.* |

The demos created a "wait, it can do *that*?" moment across the org. Engineers who had been skeptical started asking how to contribute.

### Step 3: The Plugin Marketplace

Here's where the infrastructure mattered. Rules in individual repos don't scale. An engineer on the Android team who writes a great skill for generating RecyclerView adapters shouldn't have to copy-paste it to 6 repos.

We set up a Claude Code plugin marketplace: a GitHub repository that serves as a registry of plugins containing skills, MCP server configurations, and rules that any engineer or repo can pull in.

The mechanics work like this:

```
# One-time setup: add our internal marketplace
/plugin marketplace add our-org/mobile-plugins

# Browse available plugins
/plugin install ui-generation@mobile-plugins

# Now any engineer in any repo has access to that skill
```

The marketplace changed the dynamic. Contributing wasn't just improving your own repo anymore. It was improving the entire org's capability.

| Marketplace Component | What It Contains |
|----------------------|-----------------|
| **UI Generation Skills** | Screen scaffolding from Figma specs, component generation aligned to our design system |
| **Platform Rules** | Memory management, threading patterns, navigation conventions, accessibility compliance |
| **Testing Skills** | Unit test generation that follows our test architecture, mock generation for our dependency injection setup |
| **MCP Configurations** | Pre-configured connections to our CI, design system, and internal APIs |

The marketplace also created a virtuous cycle. When an engineer installed a skill and found it 80% right, they'd fix the remaining 20% and contribute the improvement back. The harness got better every week without me doing anything.

### Lessons from Phase 2

| Lesson | Why It Matters |
|--------|---------------|
| Vision without demos is a speech. Demos without vision are a trick. You need both. | The vision provides the "why." The demos provide the "this actually works." |
| Use SMEs, not leadership, for demos | Peer influence scales. Director influence doesn't. |
| Build infrastructure for sharing, not just for creating | The marketplace turned individual effort into organizational capability. |
| Reframe AI adoption as an engineering responsibility, not optional enrichment | "Teach the agent" is a job to be done. "Try AI if you want" is a suggestion. |

---

## Phase 3: Measure

Drucker wrote: "What gets measured gets managed." Without measurement, the agent harness remains an enthusiasm project. With measurement, it becomes an organizational goal.

### Adoption Metrics

The first question: is the team actually contributing? Not just using Claude Code, but making the harness better.

| Metric | What It Tells Me | How I Track It |
|--------|-----------------|----------------|
| **# of harness contributions per engineer** | Who is actively teaching the agent | Git commits to `.claude/` directories and marketplace plugins |
| **# of rules across repos** | Breadth of coverage | Count of rule files across iOS, Android, and shared repos |
| **# of skills in the marketplace** | Depth of reusable capability | Plugin registry count |
| **# of engineers who have contributed at least once** | Adoption breadth | Git log analysis |
| **# of marketplace installs per plugin** | What's actually being used vs. sitting on the shelf | Marketplace analytics |

This is an explicit goal for my organization. When I sit down with managers in 1:1s, one of the questions is: "How are your engineers contributing to the harness?"

### Outcome Metrics (Next)

Adoption tells you if people are doing the work. It doesn't tell you if it's producing results.

| Metric | What It Would Prove | Why It's Hard |
|--------|--------------------| --------------|
| **User stories delivered per sprint** | The harness is accelerating feature delivery | Need a baseline from before the harness, and sprints have a lot of confounding variables |
| **Time from story assignment to PR** | AI-assisted development is compressing cycle time | Requires consistent measurement points across teams |
| **Code review revision cycles** | Agent-generated code is getting closer to "right" on the first pass | Needs tooling to tag AI-assisted PRs |
| **Defect escape rate for agent-assisted code** | Quality isn't degrading as speed increases | Requires defect attribution to specific PRs |

I don't have clean outcome data yet. We're weeks into measurement, not quarters. But engineers who are active harness contributors report that their skills are generating increasingly complete, convention-compliant code. The "fix the last 20%" cycle is getting shorter.

The eventual result I want: more user stories delivered per sprint with the same headcount, without an increase in defect rates. That's the test.

---

## The Maturity Model

The three phases map to a maturity model any engineering org can follow:

| Stage | Who's Involved | What's Happening | Leader's Job |
|-------|---------------|-----------------|--------------|
| **1. Pioneer** | 3-5 self-selected engineers | Grassroots experimentation, early rules in individual repos | Observe. Recognize the pattern. Don't intervene. |
| **2. Operationalize** | Entire org | Vision + demos + marketplace infrastructure | Set the vision. Empower SMEs. Build sharing infrastructure. Reframe as responsibility. |
| **3. Measure** | Entire org + leadership | Tracking adoption and outcomes, harness contributions as org goals | Define metrics. Make them visible. Connect adoption to delivery outcomes. |
| **4. Optimize** *(where we're headed)* | Entire org + AI itself | Agent harness self-improves through usage data, defect feedback loops | Build closed-loop systems where agent output quality feeds back into rule improvement. |

Stage 4 connects to the regression-to-rule pipeline I wrote about in my [previous post](001-Using-AI-as-a-Decision-Support-Layer-for-Defect-Management-at-Scale.md). When a defect escapes, the root cause analysis produces a new rule. The agent harness absorbs the lesson. That class of defect stops shipping. The org gets smarter with every failure.

---

## Advice for a Fellow Director Starting Tomorrow

**Start with the codebase, not with the tool.** The question isn't "should we use Claude Code/Copilot/Cursor?" It's "what does our codebase know, and how do we make that knowledge available to AI tools?"

**Find your pioneers. You probably already have them.** Look at commit logs. Look at who's talking about AI in Slack. Your job is to recognize them and remove obstacles.

**Invest in sharing infrastructure early.** A plugin marketplace is not optional. It's the difference between isolated experiments and organizational capability.

**Make it a goal, not a suggestion.** Not "use AI more." Contribute rules, skills, and patterns that make the codebase more agentic. "Use AI" is unmeasurable. "Contribute to the agent harness" is trackable.

**Be honest about what you don't know yet.** I can tell you adoption is up. I cannot yet tell you story throughput has increased by X%. Promising outcomes you haven't measured is the fastest way to lose credibility.

---

## The Bigger Picture

The industry data supports the direction. Anthropic's 2026 trends report found that engineers now use AI for roughly 60% of their work. Jellyfish's analysis of 20 million pull requests showed daily AI users merge about 60% more PRs. Opsera's benchmark across 250,000+ developers found AI-driven coding reduces time to pull request by up to 58%.

But the number that matters most: only 34% of organizations have successfully implemented agentic AI systems despite high investment. The bottleneck isn't technology. It's the operational work of encoding organizational knowledge, building sharing infrastructure, and measuring what matters.

That's what the agent harness is. Not a technology bet. An organizational knowledge project that uses AI as the execution layer.

Drucker wrote that the purpose of an organization is to make the strengths of people productive and their weaknesses irrelevant. The agent harness does the same thing for codebases. It takes what your best engineers know, makes it executable, and narrows the gap between your strongest and weakest contributor.

That's not a tooling upgrade. That's a leadership strategy.
