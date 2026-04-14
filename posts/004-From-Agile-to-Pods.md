# From Agile to Pods

---

I run 15 scrum teams in a program increment. Engineers across four countries. Feature requests flowing in from business units. Keep-the-lights-on work that never stops. Dependencies on infrastructure teams for auth, on application teams from business units who will eventually consume our APIs and configurations.

It works. The way a 747 works. Magnificent, complex, and requiring enormous coordination just to stay airborne. Sprint planning. Grooming. Retros. Cross-team dependency mapping. PI planning events that burn a full week. Status syncs that exist because the system is too distributed for anyone to know what's happening without a meeting.

Agile was designed for a world where building was slow and coordination was the bottleneck. When it takes two weeks to build a feature, you better spend real time making sure you're building the right one. The ceremonies exist to reduce waste in a high-cost environment.

But what happens when construction gets fast? When two engineers with AI tools can prototype and ship a feature in days? When the cost of trying something drops below the cost of planning whether to try it?

The ceremonies become the waste.

---

## The Overhead Nobody Talks About

I didn't wake up one morning philosophically opposed to Agile. I looked at what my teams were actually spending time on.

| Activity | Time Per Sprint | What It Produces |
|----------|----------------|-----------------|
| Sprint planning | 2-4 hours per team | Sequencing work already in the backlog |
| Backlog grooming | 1-2 hours per team | Refining stories that may never get picked up |
| Daily standups | ~2.5 hours per person per sprint | Surfacing blockers most people already know about |
| Retros | 1-2 hours per team | Action items that rarely get acted on |
| Dependency syncs | 1-3 hours per week | Negotiating handoffs between teams |
| PI planning | 3-5 days per quarter | Aligning 15 teams on a plan that changes within weeks |

Multiply that across 15 teams. The coordination overhead is real, and it scales with the number of teams, not the value delivered.

So the useful question becomes: where does Agile at scale break down? It breaks down when teams spend more energy coordinating than building. AI is compressing the build cycle, and that inversion is coming faster than anyone expected.

---

## What a Pod Actually Is

A pod is a fundamentally different unit of execution, not a rebranded scrum team with fewer people.

| | Scrum Team | AI Pod |
|--|-----------|--------|
| **Size** | 5-9 people | 2-4 people |
| **Composition** | Engineers + Scrum Master + PO (often part-time) | Engineers + PM (embedded, full-time) |
| **Decision authority** | Escalates through PO to PM to leadership | Pod has full authority to decide, build, and ship |
| **Planning** | 2-week sprints, quarterly PI planning | Continuous. Weekly demos replace ceremonies. |
| **Dependencies** | Managed through cross-team coordination | Eliminated by scoping work to avoid them |
| **AI** | Optional, individual | Core to how the pod operates |
| **Demo cadence** | End of sprint | Weekly or sooner |
| **Shipping** | Sprint boundary or release train | Demos ship to production |

The most important rows are the last two. In a pod, the demo is the delivery mechanism. The point of a demo isn't to show progress, it's to ship working software. If it's not ready for production, it doesn't get demoed. That constraint forces a discipline that no sprint ceremony can replicate.

The two-pizza team concept has been around for years, but that was really about minimizing coordination cost. Pods solve for something different: decision velocity. Three people who can make a call without scheduling a meeting, build without waiting on another team, and ship with AI doing the work that used to require extra headcount.

---

## Pods Have an Expiration Date

This is the part most people get wrong when they hear "pods." They assume it's a permanent reorg, a new org chart. It's closer to a deployment. You form a pod around a specific business outcome, and when that outcome is delivered, the pod dissolves. People rotate back to their teams or spin up a new pod around the next problem worth solving.

| Attribute | Scrum Team | AI Pod |
|-----------|-----------|--------|
| **Lifespan** | Permanent. Team exists across sprints and quarters. | Temporary. Lives as long as the mission requires. |
| **Exit criteria** | None. The team continues indefinitely. | Ship the business outcome. Then dissolve. |
| **Identity** | "I'm on the Platform team" | "I'm on the pod that fixed upload reliability for field agents" |
| **Success metric** | Sprint velocity, story points completed | Did the customer problem get solved? |

This is what separates pods from just running smaller scrum teams. A scrum team is a standing organizational unit that persists quarter over quarter. A pod is more like a task force: you staff it, point it at a problem, let it run, and when the job's done, you redeploy those people to the next thing.

The whole point is aligning continuous delivery to an organizational model without creating permanent new structures. When I form a pod, the org chart doesn't change. I'm just deploying a small team against a specific business outcome with a clear definition of done.

---

## The Field Service Management Pod

I wanted to prove this before pitching it broadly, so I started with a single pod.

### Three People

| Role | Team | Job |
|------|------|-----|
| Engineer 1 | My mobile org | Build it |
| Engineer 2 | My mobile org | Build it |
| PM | Field Service Management business unit | Pick the right problem, own acceptance criteria, talk to stakeholders |

No scrum master. No part-time product owner checking in twice a week. Three people with the authority to decide what to build, build it, and ship it.

The cross-cutting composition matters. The PM came from the business unit that owns the customer relationship. The engineers came from my platform team that owns the mobile codebase. Neither side could have done this alone. The PM knows which pain points are bleeding customers. The engineers know what's technically feasible in weeks versus months. Put them together and you skip three layers of requirements telephone.

### Picking the Problem

Most teams get this wrong on day one. They pick the most impressive problem, or the one with the most executive visibility, or the one that's been rotting in the backlog forever. All of those are traps for a first pod.

We applied four filters:

| Filter | Why | What We Chose |
|--------|-----|---------------|
| **Top customer pain point** | Pod must deliver real value, not an internal experiment | Attachment uploads were the #1 field agent frustration |
| **Quick to implement** | First pod needs a fast win | Scoped to upload flow improvements, not a platform rewrite |
| **Minimal dependencies** | Autonomy dies the moment you need another team | Self-contained in our codebase. No blockers. |
| **Minimal UI/UX surface** | Avoid getting stuck in a design review queue | Functional UI, not a visual redesign |

The intersection of those four filters is where your first pod should live. High customer value, low execution risk, fast cycle time.

### What the Problem Looked Like

Field service agents work in warehouses, on rooftops, in basements, in rural areas with one bar of signal. They attach photos and documents to work orders all day long. The existing upload flow was synchronous. A modal dialog locked the screen until every file finished uploading. In poor network conditions, agents sat there watching a spinner for minutes. If the upload failed, they had to re-attach the file and try again manually.

This is the kind of problem that doesn't show up in executive dashboards but drives field agents crazy every single day. And when your field agents are frustrated, their employers call your sales team.

### What We Shipped

The pod delivered a complete async attachment upload system across iOS and Android.

| Capability | What It Does |
|-----------|-------------|
| **Non-blocking uploads** | After form submission, attachments upload in the background. Agents navigate freely to the next task. No more locked screens. |
| **Intelligent retry** | Failed uploads (network drops, server errors) retry automatically with exponential backoff. Five attempts over about three minutes, silent to the user. |
| **Failure classification** | The system distinguishes between retryable failures (network timeouts, server overload) and non-retryable ones (expired auth tokens, unsupported file types). Retryable failures get automatic retry. Non-retryable failures surface immediately with the exact server error so agents know what happened. |
| **Upload manager** | A persistent screen in app settings where agents can see every upload: in progress, completed, or failed. Failed uploads show what went wrong, and agents can retry, replace the file, or delete. It survives app restarts. |
| **Telemetry** | Every upload outcome gets logged with file type, size, duration, retry count, network conditions, and failure reason. Identical event schema across both platforms. |

That last item deserves a note. The engineers didn't hand-write the telemetry instrumentation. Claude generated the full event schema and the platform-specific logging code. The engineers reviewed it, adjusted a few parameter names, and moved on. Telemetry is one of those things that's genuinely important but deeply tedious, which means it usually gets cut or half-implemented when the team runs out of time. AI is perfect for it. With the pod, telemetry shipped complete on day one.

The retry logic is worth understanding too, because it reflects the kind of real-world thinking a small autonomous team does well. When hundreds of field agents are out working simultaneously, a naive retry strategy could hammer the server. The pod designed backoff intervals (5 seconds, 15, 45, two minutes) that give the server room to recover while still being aggressive enough that agents don't notice. Auth failures and bad file types skip retry entirely because retrying won't help. These are judgment calls that happen fast when the PM and engineers are in the same room making decisions together.

### How AI Changed the Work

AI wasn't a side tool for this pod. It was baked into the daily workflow.

| Activity | Before | Pod + AI |
|----------|--------|----------|
| **Prototyping** | Designer mocks up flows, review cycle, revision, then engineering builds it | Engineers generated multiple working UI approaches in Claude Desktop. PM reacted to real implementations, not static mockups. Picked a direction the same day. |
| **Telemetry** | Engineer manually instruments events, writes a tracking plan, gets it reviewed | Claude generated the event schema and logging code. Engineers reviewed and shipped it complete. |
| **Error handling** | PM writes requirements for error states, design mocks them, engineering implements | Pod discussed failure scenarios out loud, engineers generated working error states immediately, PM validated against real customer situations on the spot. |
| **Decisions** | Engineer raises question, PO responds sometime this week, work resumes | PM is sitting right there. Question asked, answered, code written. Minutes. |

The prototyping shift matters most. In a traditional workflow, exploring three different UI approaches for an upload manager means three design iterations, three review cycles, and a decision meeting. In the pod, the engineers spun up three working prototypes, the PM compared them against actual agent workflows, and the team committed to a direction before lunch. That kind of cycle time changes what's even possible in a week.

---

## Demos as a Leadership Tool

Every week, the pod demos what they built to a broader audience than just the team.

I invited design leaders, business unit GMs, and engineering leadership peers. The feature was the excuse. The real draw was seeing three people operate at a speed that most teams of eight can't match.

| What They Saw | What It Taught Them |
|--------------|-------------------|
| Three people shipping production features weekly | You don't need 8 people and 2-week sprints |
| Engineers generating telemetry with AI | AI handles the tedious-but-important work that usually gets cut |
| UI prototyping without a design queue | Multiple approaches explored in hours, not review cycles |
| An embedded PM making decisions in real time | The #1 cause of engineering delay is waiting for a decision |
| Customer pain resolved in weeks | Pods ship business outcomes, not sprint velocity |

The demo works as a Trojan horse. Everyone shows up to see the feature, but what they actually absorb is the operating model. You can see it on their faces. Every stakeholder in the room is doing the same mental math: what would it look like if my team worked this way? That's exactly what I want them thinking about.

Leadership is largely about shaping culture, and culture is shaped by what people see, not what they're told. Weekly demos make a new way of working visible, concrete, and hard to argue with. It's easy to poke holes in a proposal. Much harder to argue with a working feature that shipped to production last Tuesday.

---

## How to Start Without Blowing Up Your Org

I'm not disbanding 15 scrum teams tomorrow. The transition is gradual and intentional.

| Phase | What Happens | Risk Level |
|-------|-------------|-----------|
| **Prove** | Form one pod. Apply the four filters. Ship weekly. Invite stakeholders to demos. | Low. Three people, bounded scope. |
| **Expand** | Form 2-3 more pods targeting different business units' top pain points. Keep Scrum for everything else. | Medium. Two operating models running in parallel. |
| **Shift** | Convert Scrum teams to pods for new feature work. Scrum handles KTLO and complex multi-team infrastructure. | Medium-high. Need clear criteria for what's pod-shaped vs. Scrum-shaped. |
| **Default** | Pods are the default for new work. Scrum survives for genuinely complex initiatives that can't be decomposed. | High change, but you have quarters of results backing it up. |

Pods and Scrum coexist during the transition. The goal isn't to pick one model. It's to learn which problems are pod-shaped (small, autonomous, close to the customer) and which are Scrum-shaped (large, interdependent, infrastructure-heavy). The exit criteria concept makes this natural. Pods form, ship, and dissolve. The Scrum teams stay stable underneath.

The first rule of org change is the same as the first rule of investing: protect what's already working while you prove what's next.

---

## What I Learned

**Autonomy matters more than AI.** AI enables the model, but what actually changes the output is giving three people the authority to decide, build, and ship without asking permission. AI just makes it feasible for three people to cover the ground that used to require eight.

**Pods are missions with expiration dates.** The moment a pod becomes permanent, it's just a small scrum team with a cooler name. The exit criteria keeps it honest. Ship the outcome, dissolve, redeploy.

**Scope selection is everything.** Wrong problem and the pod drowns in the same dependency mess as any scrum team. Right problem and it looks like magic. But there's no magic involved, just disciplined problem selection.

**Cross-cutting pods heal organizational seams.** Two engineers from my org and a PM from another business unit. The PM brought customer context my engineers would never have had. The engineers brought a delivery speed the PM had never seen. Both sides learned something they couldn't have learned inside their own org.

**Demos beat decks every time.** I could have written a proposal for pod-based delivery. Instead I formed a pod, shipped features, and invited people to watch. When stakeholders see the output, the proposal writes itself.

Every engineering leader I talk to asks about AI adoption. But the more useful question is whether your team structure actually lets AI change anything. If your engineers have Claude Code and are still sitting through two-hour sprint planning sessions, waiting days for someone to answer a product question, you've strapped a jet engine to a bicycle.

Form a pod. Pick a real customer problem. Ship it. Then do it again.
