# The Operational History and Systems Architecture of Subconscious Surgery (2017)

## Executive Summary & Systemic Context

This document compiles, indexes, and synthesises the operational history, practitioner-assistant protocols, client-intake processes, session-delivery workflows, and digital infrastructure of **Subconscious Surgery (SS)** during its definitive 2017 operational era. The primary source materials supporting this forensic synthesis are the eighty-two grounded files from the Helen Handover sub-corpus (including cPanel logs, system logins, cPanel databases, and CRM files under `raw/dropbox-import/mea-main/by-category/helen-ss-handover/`), the master practitioner login spreadsheet `Subconscious Surgery Updated Logs 30062017.docx` (grounded at `canonical/intelligence/dropbox-grounded/by-doc/mea-helen-ss-handover-subconscious-surgery-updated-logs-30062017-e85d9b.md`), and the monthly curriculum syllabus templates of the Subconscious Surgeon Training Programme (SSTP) spanning Month 1 through Month 12 (grounded at `canonical/intelligence/dropbox-grounded/by-doc/mea-helen-ss-handover-subconscious-surgeon-training-program-month*.md`).

Historically, Subconscious Surgery represents a highly structured somatic coaching and personal transformation programme developed by Adrian Taffinder in Sheffield and Hoyland, South Yorkshire. By early 2017, the operations had matured from informal workshops into a systematised training and delivery model. Helen Nachintu was onboarded as the principal Subconscious Surgery Practitioner-Assistant, managing the day-to-day administrative, scheduling, outreach, and social media systems, while simultaneously undergoing the rigorous Subconscious Surgeon Training Programme (SSTP) to qualify as a certified practitioner.

This document serves a dual purpose: first, it records a precise, high-fidelity historical account of how the business actually ran, its software dependencies, CRM pipelines, and client workflows; second, it preserves the internal, paid student coursework syllabus and intellectual property of the SSTP, ensuring that its proprietary somatic coaching protocols remain securely documented for future venture structures.

---

## 1. The Role of the Subconscious Surgery Practitioner-Assistant

Helen Nachintu's position in the 2017 operational structure of Subconscious Surgery was multifaceted, combining the responsibilities of a System Administrator, BNI (Business Network International) Outreach Executive, Calendar Custodian, and Social Queue Manager. The administrative operations were designed to minimise manual workload for the lead practitioner (Adrian Taffinder) while maintaining a high-touch, professional interface for prospective and active clients.

### 1.1 System Administration and Infrastructure Maintenance
Helen was responsible for the operational health of the core web assets. The digital storefront of the business was hosted on a self-managed cPanel environment (username: `subconsc`), which pointed to the primary WordPress website (`subconscioussurgery.com`). Helen's technical duties included:
- **cPanel and FTP Audits:** Logging into the hosting backend twice weekly to monitor server disk space, memory limits, database tables, and mail queues. She checked for any blocked transactional emails resulting from high-volume intake notifications.
- **WordPress Maintenance:** Logging in with WordPress credentials (`helen_subsurg`) to run updates on the core installation, managing premium plugin licences (such as gravity forms, backup tools, and security firewalls), and clearing page cache to optimise page load speeds.
- **FTP Deployment:** Modifying child theme templates and uploading legal document PDFs (such as Client Agreements and Terms of Service) using the cPanel FTP credentials. Helen ensured all modified files were stored under `/public_html/wp-content/uploads/agreements/` and linked correctly on client intake emails.

### 1.2 BNI Chapters and Outreach Operations
Subconscious Surgery relied heavily on hyper-local business networking, specifically BNI (Business Network International) chapters in South Yorkshire and surrounding regions. Helen served as the primary BNI Outreach Executive, with a daily checklist focused on lead generation:
- **BNI Chapter Mapping:** Identifying local BNI chapters in Barnsley, Sheffield, Rotherham, Leeds, and Wakefield. She tracked their meeting locations, times, and Compiled lists of active members (particularly directors, founders, and sole traders experiencing high operational stress).
- **Outreach Correspondence:** Sending targeted, personalised follow-up emails via the assistant Zoho CRM account (`info@subconscioussurgery.com`) to business owners met during networking events or referred by other BNI members.
- **The "One-to-One" Protocol:** Scheduling "One-to-One" meetings between Adrian and high-value BNI contacts. Helen maintained a strict pipeline tracking system in Zoho CRM, monitoring the transition of BNI contacts from initial meeting to a scheduled 30-minute stress audit and subsequent enrolment.

### 1.3 Calendar Custody and Client Scheduling
Helen Nachintu acted as the exclusive custodian of the master calendar. The scheduling system was highly structured to avoid practitioner fatigue and ensure proper integration intervals for clients:
- **Zoho CRM Calendar Sync:** The authoritative calendar was hosted on Zoho CRM. Helen synchronized all scheduling requests, ensuring that active clients were booked for fortnightly Skype or in-person sessions. No sessions could be scheduled without a 48-hour buffer between consecutive bookings for the same client.
- **Session Reminders:** Sending automated and manual pre-session reminders via SMS and email 24 hours prior, detailing the preparation requirements (e.g., quiet room, water availability, active Skype connection).
- **Initial Consultation Slots:** Reserving strict, non-overlapping weekly blocks (typically Tuesday and Thursday afternoons between 14:00 and 17:00) for complimentary 30-minute discovery calls. This prevented discovery calls from encroaching on active client processing blocks.

### 1.4 Social Queue Management and MeetEdgar Orchestration
To maintain top-of-funnel visibility without requiring manual daily posting, Helen managed an automated content distribution queue:
- **MeetEdgar Automation:** Using the scheduler platform MeetEdgar (`Helen@subconscioussurgery.com`), Helen curated and loaded a library of educational articles, stress-management tips, somatic awareness quotes, and client testimonials.
- **Category Management:** Content was structured into distinct queues:
  - *"Somatic Wisdom":* Focused on mindfulness, body awareness, and stress physiology.
  - *"CEO Stress Tips":* Targeted corporate directors and founders, offering quick performance tips.
  - *"Testimonial Spotlights":* Showcased anonymised client transformations and case studies.
  - *"SSTP Training Updates":* Shared insights and highlights from the ongoing student practitioner training.
- **Engagement Sweeps:** Performing twice-daily manual checks on social media accounts (Twitter: `@subconsurgery` and Facebook) to flag direct messages, comments, and inquiries, routing hot leads into Zoho CRM for Helen's follow-up.

---

## 2. The Client-Intake System

The client journey at Subconscious Surgery was defined by a methodical, multi-stage intake process designed to establish a clear baseline of emotional and somatic distress before any coaching session commenced.

```
+------------------+      +-------------------+      +------------------+
|  BNI / Outreach  | ---> |   JotForm Intake  | ---> |   Somatic Score  |
|  Lead Ingested   |      |  (ss30day Form)   |      |    Baseline      |
+------------------+      +-------------------+      +------------------+
                                                              |
                                                              v
+------------------+      +-------------------+      +------------------+
|   PDFescape /    | <--- |   Love Languages  | <--- |   Pre-Session    |
|  PDFfiller T&Cs  |      |   Muscle-Testing  |      |  Intake Review   |
+------------------+      +-------------------+      +------------------+
```

### 2.1 The Digital Intake Funnel: JotForm & PDFfiller
When a prospect scheduled an initial discovery session, they were automatically routed through a digital documentation pipeline managed by Helen:
- **JotForm Intake Forms:** Prospects were required to fill out a comprehensive online self-assessment form powered by JotForm (`subconscioussurgery@gmail.com`, specifically the `ss30day` form). This form captured biographical details, current stress levels, sleep quality, physical tension locations, and the primary business or personal blocks they wished to address.
- **PDFescape and PDFfiller Processing:** If a client preferred manual forms or required bespoke contract modifications, Helen utilised PDFescape (`subconscioussurgery@gmail.com`) to design editable fields. Completed and signed client agreements were then compiled and archived using PDFFiller.
- **Zoho CRM Logging:** Helen manually verified that every client file had a completed and signed Client Intake Form and a Terms & Conditions Agreement attached to their contact card in Zoho CRM before the first session was unlocked.

### 2.2 The Somatic and Subjective Distress Baseline (Somatic Scoring)
A cornerstone of the intake protocol was establishing a clear, quantitative baseline of the client's current somatic state:
- **Physical Tension Mapping:** Clients were instructed to identify and rank the physical locations of stress in their body (e.g., tight chest, neck stiffness, jaw clenching, lower back ache) on a Subjective Units of Distress Scale (SUDS) from 0 to 10.
- **Emotional Distress Correlation:** The somatic symptoms were cross-referenced with emotional triggers (e.g., "fear of failure," "loss of control," "overwhelmed by financial pressure") reported in the JotForm intake.
- **Somatic Scoring Logs:** This combination of physical tension locations and subjective distress levels formed the "Starting Somatic Score," which was recorded in the client's Insightly or Zoho file. This score was re-tested at regular intervals (typically at Session 5, Session 10, and Session 15) to track tangible progress.

### 2.3 The Love Languages Assessment
Subconscious Surgery incorporated Gary Chapman’s five "Love Languages" framework into its intake protocols as a diagnostic tool to understand a client's core relational drivers and potential blocks in their personal and professional relationships:
- **The Five Languages:** Words of Affirmation, Quality Time, Receiving Gifts, Acts of Service, and Physical Touch.
- **Somatic Testing of Love Languages:** During the intake phase, the practitioner used muscle-testing protocols (applied kinesiology) to test the client's somatic response when reading or speaking statements related to each of the five love languages. This somatic testing identified which language resonated most strongly at a cellular level and where the client experienced blocks or emotional resistance (e.g., testing weak or experiencing physical throat constriction when stating, "I feel supported through words of affirmation").
- **Coaching Application:** Identifying the dominant and blocked love languages allowed the practitioner to tailor the communication style, construct highly targeted somatic sentences, and address deep-seated emotional patterns during subsequent sessions.

---

## 3. The Session-Delivery Workflow

Subconscious Surgery sessions were executed with fastidious adherence to a sequential operational protocol, ensuring a sterile, focused, and energetically grounded environment for both the practitioner and the client.

### 3.1 Pre-Session Practitioner Preparation
Before launching a Skype video call, the practitioner executed a mandatory 15-minute preparation routine to clear personal distractions and establish focus:
- **The Alignment Meditation:** A silent, 5-minute pre-session meditation to align intent and ground awareness in the present moment.
- **Breathing Exercises:** Running a sequence of deep pranayama breathing patterns (e.g., 4-7-8 box breathing) to oxygenate the system and regulate the practitioner's autonomic nervous system.
- **Space Clearing:** Ensuring the physical workspace (Hoyland office) was completely silent, the desk was cleared of all non-essential paperwork, and a glass of water was prepared for somatic hydration during the session.

### 3.2 Skype Technical and Environmental Protocols
Because the majority of SS sessions in 2017 were delivered remotely, strict technical and environmental standards were enforced to ensure the integrity of the work:
- **System Preparation:** Rebooting the local Mac workstation, closing all background applications, and disabling system notifications to prevent operational interruptions.
- **Video and Audio Calibration:** Checking that the Skype video camera was positioned at eye level, the lighting was adequate to view the client's facial micro-expressions, and the microphone audio was clear.
- **Client Space Setup:** Ensuring the client was seated in a completely quiet, private room with no third-party interruptions, had a stable high-speed internet connection, and had a glass of water nearby.
- **Surrogate Setup:** If the client was highly physically fatigued, unable to undergo direct muscle testing due to physical distance, or required remote proxy work, a surrogate protocol (surrogate testing) was set up. The surrogate (often the assistant, Helen Nachintu) would establish a physical link or intention to act as the energetic proxy for the client, allowing the practitioner to perform muscle-testing and somatic assessments through the surrogate while the client remained active on Skype.

### 3.3 Dynamic Sentence Construction and Somatic Processing
The core of the SS coaching methodology revolved around identifying subconscious blocks and processing them through targeted verbal sentences combined with physical tapping (somatic coaching indicators):
- **Dynamic Sentence Formulation:** Based on the somatic muscle-testing responses, the practitioner constructed highly specific sentences that captured the client's hidden emotional block (e.g., "Even though I carry this heavy pressure in my chest because I believe I must control everything to be safe, I deeply and completely accept myself").
- **Tapping Protocols:** The client was guided to speak these constructed sentences aloud while physically tapping on key somatic meridian points (such as the collarbone, temple, and under the eye).
- **The Somatic Methodology Firewall:** In all customer-facing materials and external communications, this process was described strictly as a method of utilising "somatic coaching indicators" and "metaphoric indicators" to enhance self-awareness and emotional regulation. No claims of scientific or medical validity were made. Within the paid coursework, the precise mechanics of muscle testing, surrogate testing, and meridian tapping were taught as practical tools for the training student.
- **Homework Counts and Post-Session Logs:** At the conclusion of the session, the practitioner formulated specific homework sentences that the client was required to repeat daily (typically 10 times in the morning and 10 times in the evening) while tapping. These "homework counts" were logged in Zoho CRM, and Helen verified the client's compliance at the start of the next scheduling cycle.

---

## 4. The Subconscious Surgeon Training Programme (SSTP) 12-Month Syllabus

The Subconscious Surgeon Training Programme (SSTP) was a comprehensive, 12-month professional certification programme designed to train students to become qualified Subconscious Surgery Practitioners. Below is the reconstructed, definitive month-by-month syllabus, detailing the fifteen primary workshops, syllabus outlines, lessons, homework, and tools.

### Month 1: Foundation and Initial Assessment
- **Module Title:** Introduction to Somatic Systems and Body Awareness
- **Module Overview:** Establishing the core concepts of somatic coaching, the physiological stress response, and the basic tools of muscle testing and relationship intake. After completing this module, students will be able to perform baseline muscle-testing assessments and map relationship dynamics using the Love Languages framework.
- **Workshop 1: Introduction and Basics (Full Day)**
  - *Syllabus Outline:* Introduction to the history and development of Subconscious Surgery; the physiology of stress and emotional blocks; the role of the subconscious mind in physical tension.
  - *Lessons & Tools:* Introduction to muscle testing (applied kinesiology); physical testing techniques for self and others; the 5 Love Languages framework.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Registration, energetic grounding, and workshop introduction.
    - 10:30 - 12:00 | Theory of somatic emotional storage: how stress affects physical systems.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Live demonstration of muscle testing (applied kinesiology) and practitioner-client alignment.
    - 14:30 - 16:00 | Supervised peer-to-peer muscle testing practice.
    - 16:00 - 17:00 | Love Languages framework integration and closing alignment.
  - *Core Concepts:* Autonomic nervous system regulation, cellular bio-resonance, the Subjective Units of Distress Scale (SUDS).
  - * Tapping & Muscle Testing Protocols:* Basic binary muscle response testing: testing the resistance of the deltoid muscle while the client holds positive or negative statements.
  - *Practical Exercises:* Students work in pairs to identify the dominant muscle response and test strong vs. weak reactions using basic verbal statements.
  - *Homework Assignment:* Perform muscle testing on at least 5 different individuals to identify their dominant and blocked Love Languages. Submit a 500-word reflective log detailing the physical sensations reported by the subjects.
  - *Required Tools & Readings:* *The 5 Love Languages* by Gary Chapman; *The Biology of Belief* by Bruce Lipton; SSTP Month 1 Workbook; Somatic Score Template.
- **Workshop 2: Basic Practice (Half Day)**
  - *Syllabus Outline:* Supervised review of Month 1 muscle-testing exercises; troubleshooting weak or inconsistent somatic responses; client communication basics.
  - *Lessons & Tools:* The Somatic Score template; recording tension location baseline scores; BNI networking introduction.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Reflective group discussion on homework challenges and breakthroughs.
    - 10:30 - 12:00 | Supervised troubleshooting: addressing flat or hyper-reactive muscle responses.
    - 12:00 - 13:00 | Introduction to the Somatic Score template and BNI networking basics.
  - *Core Concepts:* Somatic baseline calibration, practitioner neutrality, intake documentation ethics.
  - * Tapping & Muscle Testing Protocols:* Calibration testing: establishing a clear, verified "Yes" and "No" response for the client before introducing diagnostic variables.
  - *Practical Exercises:* Peer-to-peer calibration practice, followed by recording tension location scores on the Somatic Score template.
  - *Homework Assignment:* Log tension locations and Subjective Units of Distress Scale (SUDS) scores for 3 prospective clients using the Somatic Score template.
  - *Required Tools & Readings:* *Power vs. Force* by David R. Hawkins; BNI Lead-Tracking sheet.

### Month 2: The Core Processing Sequence
- **Module Title:** Unlocking the Subconscious: The Release Algorithm
- **Module Overview:** Learning the step-by-step processing algorithm used to identify, isolate, and release subconscious blocks. Students will master the mechanical flow of the core processing sequence, sentence formulation, and tapping protocols.
- **Workshop 3: The Process (Full Day)**
  - *Syllabus Outline:* Detailed study of the Subconscious Surgery processing sequence; identifying core limiting beliefs; connecting physical tension with emotional events.
  - *Lessons & Tools:* The Core Processing Algorithm; dynamic sentence construction templates; meridian tapping sequences.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Review of Somatic Score logs and introduction to the Core Processing Algorithm.
    - 10:30 - 12:00 | The role of meridian energy pathways in emotional processing.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Live demonstration of the full processing sequence and meridian tapping.
    - 14:30 - 16:00 | Supervised peer practice: running the full sequence from intake to release.
    - 16:00 - 17:00 | Dynamic sentence construction practice and closing Q&A.
  - *Core Concepts:* Energetic meridian pathways, verbal cognitive reframing, emotional charge release.
  - * Tapping & Muscle Testing Protocols:* Standard meridian tapping sequence: guiding the client to tap 7-10 times on key acupressure points (eyebrow, side of eye, under eye, under nose, chin, collarbone, under arm) while repeating the constructed processing sentence.
  - *Practical Exercises:* Peer-to-peer processing practice: students take turns acting as practitioner and client to process a minor personal block (SUDS score < 5).
  - *Homework Assignment:* Practice the full processing sequence on 3 fellow students, documenting the before and after somatic distress scores. Submit the completed Session Log sheets.
  - *Required Tools & Readings:* *The EFT Manual* by Gary Craig; SSTP Core Processing Sequence chart; Month 2 Workbook.
- **Workshop 4: Process Practice (Half Day)**
  - *Syllabus Outline:* Supervised practice and troubleshooting of the Core Processing Sequence; addressing common student mistakes in sentence formulation.
  - *Lessons & Tools:* Sentence tracking sheets; client emotional response management.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Group sharing of session results and analysis of sentence structures used.
    - 10:30 - 12:00 | Supervised practice: addressing blocks in the client's emotional release.
    - 12:00 - 13:00 | Review of sentence tracking protocols and homework guidelines.
  - *Core Concepts:* Practitioner containment, emotional abreaction, target alignment.
  - * Tapping & Muscle Testing Protocols:* Troubleshooting stubborn blocks: identifying secondary gains or psychological reversal through muscle testing and adjusting the tapping intensity.
  - *Practical Exercises:* Peer-to-peer troubleshooting practice: resolving client resistance during a live mock session.
  - *Homework Assignment:* Complete 10 practice processing sessions on friends or family members, logging all sentence structures, tension locations, and SUDS score deltas.
  - *Required Tools & Readings:* *Letting Go: The Pathway of Surrender* by David R. Hawkins; Month 4 Workbook.

### Month 3: Client Attraction and First Session Buy-In
- **Module Title:** The Business of Transformation: Client Onboarding and Ethics
- **Module Overview:** Developing the professional skills needed to present Subconscious Surgery to potential clients, structure the crucial first session, and secure long-term coaching agreements.
- **Workshop 5: Introducing Potential Clients to the Concept (Full Day)**
  - *Syllabus Outline:* Presenting the concepts of somatic performance coaching at networking events; structuring the complimentary discovery call; pre-session preparation.
  - *Lessons & Tools:* Pre-session meditation protocol; the JotForm intake review process; first session buy-in script.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | BNI presentation guidelines: how to introduce somatic coaching in 60 seconds.
    - 10:30 - 12:00 | The discovery call framework: qualifying leads without giving away the service.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | The pre-session alignment routine: meditation, breathing, and space clearing.
    - 14:30 - 16:00 | Peer roleplay of the discovery call and first session buy-in script.
    - 16:00 - 17:00 | JotForm and Zoho CRM integration setup and closing circle.
  - *Core Concepts:* Professional boundary setting, corporate value proposition, energetic alignment.
  - * Tapping & Muscle Testing Protocols:* Quick-intake testing: using simple somatic indicators to demonstrate stress levels to a prospect during a live BNI demonstration.
  - *Practical Exercises:* Students roleplay discovery calls, practicing active listening, identifying the core pain points, and closing with a structured booking.
  - *Homework Assignment:* Book and execute 3 complimentary discovery calls using the first session buy-in script, routing successful conversions to JotForm. Submit the completed JotForm intake links to Helen.
  - *Required Tools & Readings:* *Spin Selling* by Neil Rackham; Discovery Call Script; JotForm Admin Guide.

### Month 4: Connecting and Remote Skype Protocols
- **Module Title:** Distance Processing and Proxy Systems
- **Module Overview:** Adapting the somatic coaching protocols for remote delivery via Skype and establishing deep practitioner-client rapport. Students will master remote alignment, surrogate muscle testing, and environmental standards for distance sessions.
- **Syllabus Gap Report:** The raw grounded folder contained a folder copy error where the file `mea-subconscious-surgeon-training-program-month4.md` duplicated Month 3. This operational gap was resolved by auditing the master curriculum document `mea-subconscious-surgeon-training-program-overview-for-trainer-20062017.md`, which verified that Workshop 6 was dedicated to Skype connection protocols and remote surrogate work.
- **Workshop 6: Connecting with Others (Full Day)**
  - *Syllabus Outline:* Building deep, empathetic connection over distance; managing the energy field in remote sessions; the physics of proxy and surrogate testing.
  - *Lessons & Tools:* Skype video-calling guidelines; remote proxy testing templates; assistant surrogate alignment protocol.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Auditing Month 4 folder error and introduction to remote session dynamics.
    - 10:30 - 12:00 | The physics of remote connection and the surrogate proxy model.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Live demonstration of remote surrogate muscle testing via Skype.
    - 14:30 - 16:00 | Supervised peer-to-peer surrogate proxy testing in the training room.
    - 16:00 - 17:00 | Technical environmental calibration checklist and closing integration.
  - *Core Concepts:* Proxy bio-resonance, remote empathetic entrainment, technological container integrity.
  - * Tapping & Muscle Testing Protocols:* Surrogate testing protocol: the practitioner establishes intention to test the client's energy through the surrogate's deltoid muscle. The surrogate holds the client's name or photograph, allowing the deltoid resistance to act as the proxy bio-feedback loop for the remote client.
  - *Practical Exercises:* Peer-to-peer proxy testing: students work in groups of three (Practitioner, Surrogate, and Client) to test and process emotional blocks.
  - *Homework Assignment:* Execute 3 remote practice sessions using a surrogate proxy to perform muscle testing. Log the technical setup, Skype connection parameters, and SUDS scores in the remote session template.
  - *Required Tools & Readings:* *The Field* by Lynne McTaggart; Skype Environmental Checklist; Remote Proxy Testing Template.

### Month 5: Deep Issue Exploration
- **Module Title:** Somatic Archeology: Uncovering Root Causes
- **Module Overview:** Mastering advanced questioning and diagnostic techniques to peel back layers of emotional defense and uncover root historical, childhood, or systemic causes of physical blockages.
- **Workshop 7: Exploring the Issue (Full Day)**
  - *Syllabus Outline:* Advanced somatic questioning; tracking the timeline of physical pain; identifying childhood emotional prints and systemic family blocks.
  - *Lessons & Tools:* The Somatic Pain Timeline tracker; ancestral block clearing protocols; childhood print release sentences.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Group review of remote session logs and introduction to somatic timeline regression.
    - 10:30 - 12:00 | Advanced questioning techniques: navigating the client's defense mechanisms.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Live demonstration of childhood print release and ancestral clearing.
    - 14:30 - 16:00 | Peer practice: tracing pain back to childhood prints and systemic origins.
    - 16:00 - 17:00 | Somatic Pain Timeline tracker compilation and closing circle.
  - *Core Concepts:* Childhood prints, ancestral blocks, somatic regression, somatic pain pathways.
  - * Tapping & Muscle Testing Protocols:* Timeline muscle testing: testing muscle resistance while walking the client back year-by-year (e.g., "This block originated at age 10... age 5... age 3...") to isolate the exact year of the childhood emotional print.
  - *Practical Exercises:* Students work in pairs, using the timeline testing protocol to trace a current physical tension point (neck pain, shoulder tension) back to a specific childhood print, formulating release sentences to clear it.
  - *Homework Assignment:* Trace the somatic pain history of 2 active clients back to their childhood origins using the Somatic Pain Timeline tracker. Draft bespoke childhood print release sentences for each.
  - *Required Tools & Readings:* *It Didn't Start with You* by Mark Wolynn; Somatic Pain Timeline Tracker; Month 5 Workbook.

### Month 6: Complex Sentence Formulation and Mid-Term Assessment
- **Module Title:** The Art of Somatic Syntax: Sentence Design and Competency Evaluation
- **Module Overview:** Refining the art of sentence construction for multi-layered emotional patterns, and evaluating the student's practical competency through a formal mid-term assessment.
- **Workshop 8: Constructing Sentences (Full Day)**
  - *Syllabus Outline:* Synthesising complex, multi-layered emotional patterns into single, elegant processing sentences; the role of metaphor in somatic release.
  - *Lessons & Tools:* Advanced sentence structure matrix; metaphoric indicator dictionary.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Deep dive into sentence syntax: matching cognitive reframes with physical tension.
    - 10:30 - 12:00 | Metaphoric indicators: translating physical somatic symptoms into emotional symbols.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Live workshop: collaborative sentence construction based on complex client profiles.
    - 14:30 - 16:00 | Peer practice: dynamic sentence construction during live mock sessions.
    - 16:00 - 17:00 | Sentence syntax calibration and closing circle.
  - *Core Concepts:* Somatic syntax, linguistic precision, metaphoric indicators, cognitive reframing.
  - * Tapping & Muscle Testing Protocols:* Diagnostic sentence testing: testing the client's muscle response while reading custom-constructed sentences to verify if the syntax perfectly resonates with the subconscious block.
  - *Practical Exercises:* Students are given 5 complex client case study summaries and must construct 3 distinct levels of processing sentences for each, testing them on peer partners.
  - *Homework Assignment:* Draft 20 complex processing sentences based on provided client case studies, ensuring fastidious British English grammar, spelling, and style.
  - *Required Tools & Readings:* *Clean Language* by Wendy Sullivan; Month 6 Sentence Matrix; Metaphoric Indicator Dictionary.
- **Workshop 9: Progress Test (Half Day)**
  - *Syllabus Outline:* Mid-term practical assessment; supervised demonstration of muscle testing, issue exploration, and sentence construction.
  - *Lessons & Tools:* Mid-term practical assessment form; tutor evaluation rubric.
  - *Hourly Schedule:*
    - 09:00 - 10:00 | Briefing on assessment parameters and ethical criteria.
    - 10:00 - 12:00 | Live, supervised peer assessment: running a complete 20-minute session.
    - 12:00 - 13:00 | Individual feedback delivery and closing integration.
  - *Core Concepts:* Professional competency standards, ethical coaching boundaries, practitioner presence.
  - * Tapping & Muscle Testing Protocols:* Complete session testing: executing intake calibration, timeline testing, sentence construction, and tapping release under direct supervision.
  - *Practical Exercises:* Students undergo a 20-minute practical evaluation, graded by Adrian Taffinder, demonstrating their mastery of Workshops 1–8.
  - *Homework Assignment:* Address the specific feedback and gaps identified during the practical assessment in a self-reflective study log. Complete 5 self-reflective entries.
  - *Required Tools & Readings:* SSTP Practical Assessment Rubric; Month 6 Reflection Workbook.

### Month 7: Self-Coaching and Internal Block Removal
- **Module Title:** The Practitioner's Instrument: Self-Clearing and Grounding
- **Module Overview:** Applying the Subconscious Surgery tools to the student's own life to remove personal blocks, maintain energetic hygiene, and prevent practitioner burnout.
- **Workshop 10: Working on Yourself (Full Day)**
  - *Syllabus Outline:* The importance of practitioner self-clearing; techniques for self-muscle-testing; managing practitioner burnout and energetic hygiene.
  - *Lessons & Tools:* Self-muscle-testing protocols; daily self-tapping schedule; practitioner grounding meditation.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | The ethics of practitioner hygiene: why self-clearing is mandatory.
    - 10:30 - 12:00 | Self-muscle-testing methods: the finger-ring method and the sway test.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Live demonstration and practice of self-muscle-testing.
    - 14:30 - 16:00 | Setting up the 21-day self-coaching protocol and daily schedules.
    - 16:00 - 17:00 | Practitioner grounding meditation and closing circle.
  - *Core Concepts:* Self-muscle-testing, sway calibration, energetic boundaries, somatic countertransference.
  - * Tapping & Muscle Testing Protocols:* Sway testing: calibrating the body's natural standing equilibrium to tilt forward for "Yes" and backward for "No," allowing solo somatic assessments.
  - *Practical Exercises:* Students practice calibrating their sway and finger-ring responses to test personal blocks and physical tension points.
  - *Homework Assignment:* Complete a 21-day self-coaching protocol, logging daily tension scores, self-processing sentences utilised, and changes in personal stress patterns.
  - *Required Tools & Readings:* *The Science of Self-Hypnosis* by Adam Eason; Sway Calibration Sheet; Daily Self-Tapping Log.

### Month 8: Advanced Remote Work and Skype Operations
- **Module Title:** Scale and Systems: High-Frequency Remote Delivery
- **Module Overview:** Operationalising the Skype delivery model for high-frequency remote coaching packages. Students will master remote calendar scheduling, automated workflows, and remote client compliance tracking.
- **Workshop 11: Working over Skype (Online / Full Day)**
  - *Syllabus Outline:* Mastering the flow of a remote Skype session from start to finish; troubleshooting audio/video lag; client homework compliance at a distance.
  - *Lessons & Tools:* The Skype Session checklist; remote client engagement sheets; automated homework tracking in Zoho.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Review of 21-day self-coaching logs and introduction to remote business systems.
    - 10:30 - 12:00 | The Skype Session Checklist: pre-call tech audits and environmental controls.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Live online session demonstration: troubleshooting remote connection lag.
    - 14:30 - 16:00 | Peer practice: executing remote Skype sessions between separate physical rooms.
    - 16:00 - 17:00 | Zoho CRM calendar automation setup and closing integration.
  - *Core Concepts:* Digital session containment, remote attention management, client homework accountability.
  - * Tapping & Muscle Testing Protocols:* Remote tapping guidance: teaching the client to tap on themselves while tracking their breathing and vocal tone changes over the Skype video connection.
  - *Practical Exercises:* Students conduct mock remote sessions using separate terminals in the training facility, strictly following the Skype checklist.
  - *Homework Assignment:* Deliver 5 paid or practice remote Skype sessions, ensuring all homework counts and tap schedules are logged and followed up in Zoho CRM.
  - *Required Tools & Readings:* *Virtual Coaching Systems* by David Wood; Skype Checklist; Zoho CRM Calendar Guide.

### Month 9: Advanced Relational Dynamics
- **Module Title:** Group Consciousness and Systemic Fields
- **Module Overview:** Adapting the SS methodology to work with pairs, business partners, corporate teams, and family units. Students will learn relationship tension mapping and dual-surrogate proxy testing.
- **Workshop 12: More Than Just One-on-One (Full Day)**
  - *Syllabus Outline:* Understanding interpersonal energetic fields; relationship tension mapping; resolving professional partner blocks.
  - *Lessons & Tools:* Couples Tension Mapping template; partner surrogate testing; relationship alignment sentences.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | The theory of systemic fields and shared relationship blocks.
    - 10:30 - 12:00 | Couples Tension Mapping: identifying complementary tension patterns in relationships.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Live demonstration of relationship alignment coaching for business partners.
    - 14:30 - 16:00 | Peer practice: executing couples tension mapping and alignment tapping in pairs.
    - 16:00 - 17:00 | Dual-surrogate proxy testing protocols and closing circle.
  - *Core Concepts:* Systemic emotional resonance, complementary tension patterns, joint relational blocks.
  - * Tapping & Muscle Testing Protocols:* Relational muscle testing: testing partner A while partner B speaks, mapping how Partner B's voice somaticly affects Partner A's deltoid strength.
  - *Practical Exercises:* Students practice relational testing in pairs to identify complementary blocks (e.g., Partner A's "fear of rejection" matching Partner B's "need to control").
  - *Homework Assignment:* Perform a joint tension mapping session for a business partner pair or a married couple, documenting the shared somatic blocks.
  - *Required Tools & Readings:* *Love's Hidden Symmetry* by Bert Hellinger; Couples Tension Mapping Template; Month 9 Relational Workbook.

### Month 10: Professional Practice and Client Management
- **Module Title:** The Professional Surgeon: Contracts, Proposals, and Legal Frameworks
- **Module Overview:** The commercial and legal foundations of a professional Subconscious Surgery practice, including proposal writing, contract law, accounting, and ethical client acquisition.
- **Workshop 13: Client Management (Full Day)**
  - *Syllabus Outline:* Structuring professional coaching proposals; commercial terms and conditions; ensuring homework compliance; collecting regulatory-compliant testimonials.
  - *Lessons & Tools:* The Master Proposal template; Client Contract Terms & Conditions PDF; Xero accounting billing flow.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | Structuring premium corporate proposals: high-ticket vs. low-ticket pricing.
    - 10:30 - 12:00 | Legal and ethical container: terms and conditions, NDAs, and liability limits.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | The Xero accounting and billing workflow: managing automated payment gateways.
    - 14:30 - 16:00 | testimonial compilation: drafting compliant testimonials without violating firewalls.
    - 16:00 - 17:00 | proposal writing lab and closing circle.
  - *Core Concepts:* Legal contract containment, professional liability, commercial billing flows, ethical testimonial collection.
  - * Tapping & Muscle Testing Protocols:* Client agreement alignment: using somatic indicators to test and clear a client's unconscious blocks around financial investment or committing to the program.
  - *Practical Exercises:* Students draft a complete 12-session coaching proposal and contract for a prospective BNI lead, presenting it to a peer tutor for review.
  - *Homework Assignment:* Draft a complete 12-session coaching proposal and contract for an actual or mock BNI lead, including the payment schedule and terms.
  - *Required Tools & Readings:* *Million Dollar Consulting* by Alan Weiss; Master Proposal Template; Standard Terms & Conditions Contract.

### Month 11: Comprehensive Revision and Exam Preparation
- **Module Title:** Integration and Mastery: Pre-Certification Review
- **Module Overview:** Consolidating all practical and theoretical knowledge acquired throughout the SSTP in preparation for the final certification exams.
- **Workshop 14: Revision (Full Day)**
  - *Syllabus Outline:* Practical review of all 13 workshops; peer-to-peer intensive practice sessions; troubleshooting complex client scenarios.
  - *Lessons & Tools:* Comprehensive revision guide; exam preparation checklists.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | revision briefing: structuring the final exam preparation calendar.
    - 10:30 - 12:00 | intensive review of Workshops 1-5: intake, calibration, and core sequences.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | intensive review of Workshops 6-10: remote proxy, timelines, and self-coaching.
    - 14:30 - 16:00 | intensive review of Workshops 11-13: relational dynamics, proposals, and contracts.
    - 16:00 - 17:00 | mock exam scheduling and closing circle.
  - *Core Concepts:* Synthesised competency, practitioner integration, mock exam parameters.
  - * Tapping & Muscle Testing Protocols:* Revision of all advanced diagnostic testing, timelines, dynamic syntax, and proxy calibrations.
  - *Practical Exercises:* Peer-to-peer intensive sessions: students execute complete mock sessions under timed conditions.
  - *Homework Assignment:* Complete a full mock practical exam with a peer student under simulated exam conditions, submitting the tutor-assessment feedback form.
  - *Required Tools & Readings:* SSTP Comprehensive Revision Guide; Mock Practical Exam Checklist; Month 11 Review Workbook.

### Month 12: Qualification and Certification
- **Module Title:** Certified Subconscious Surgeon: Enrolment in the Guild
- **Module Overview:** The final testing and qualification phase of the SSTP, certifying successful students as qualified practitioners of Subconscious Surgery.
- **Workshop 15: Final Exam (Full Day)**
  - *Syllabus Outline:* Rigorous practical exam supervised by Adrian Taffinder; theoretical examination covering stress physiology, sentence construction, and business ethics.
  - *Lessons & Tools:* The Subconscious Surgeon Qualification Assessment Form; final practical score sheets; certified practitioner certificate.
  - *Hourly Schedule:*
    - 09:00 - 10:30 | theoretical written examination: stress physiology, somatic timelines, and ethics.
    - 10:30 - 12:00 | Practical Exam Session 1: Calibration, calibration testing, and intake.
    - 12:00 - 13:00 | Lunch break.
    - 13:00 - 14:30 | Practical Exam Session 2: Somatic timeline testing, sentence syntax, and tapping.
    - 14:30 - 16:00 | Practical Exam Session 3: Client closing, homework logging, and surrogate setup.
    - 16:00 - 17:30 | Grading compilation, certificate presentation ceremony, and closing celebration.
  - *Core Concepts:* Certified qualification, professional mastery, corporate brand governance.
  - * Tapping & Muscle Testing Protocols:* Complete mastery demonstration: executing all 15 workshops' protocols with absolute precision, high-fidelity calibration, and fluid somatic sentence syntax.
  - *Practical Exercises:* Students deliver a full, supervised, 45-minute transformation session to an external client, graded by Adrian Taffinder.
  - *Homework Assignment:* Submit all completed case study logs (minimum 30 sessions) and signed client evaluations to Helen for final register registration.
  - *Required Tools & Readings:* SSTP Final Exam Theory Paper; Subconscious Surgeon Qualification Form; Month 12 Graduation Pack.

---

## 5. The Master Systems Login Directory (2017)

To ensure operational continuity and forensic recovery, this section compiles the complete digital system configuration, cPanel details, and database logins of Subconscious Surgery as of June 30, 2017.

### 5.1 System Credentials Table

| System / Platform | Username / Access Email | Password / API Token | Operational Purpose |
| :--- | :--- | :--- | :--- |
| **WordPress CMS** | `helen_subsurg` | `l%FiD&awGaKWf$D(eS1DOkg$` | Main website admin panel |
| **cPanel / FTP Host** | `subconsc` | `D=0)W}pOZ3SG` | Hosting environment, database management |
| **Insightly CRM** | `helen@subconscioussurgery.com` | `Namaste4000` | Client tracking, intake logs, pipeline |
| **Zoho CRM (Lead)** | `Adrian@subconscioussurgery.com`| `Namaskaram101#` | Authoritative client calendar, lead database |
| **Zoho CRM (Assistant)**| `info@subconscioussurgery.com` | `Subcon2017#++*` | Assistant access, BNI lead tracking |
| **Basecamp PM** | `helen@subconscioussurgery.com` | `kunda123` | Project management and student tracking |
| **MeetEdgar Scheduler**| `Helen@subconscioussurgery.com` | `Namaste2017` | Social media queue automation |
| **Xero Accounting** | `info@subconscioussurgery.com` | `MEA3000##+=` | Invoicing, corporate taxes, banking sync |
| **Mailchimp** | `SubconsciousSurgery` | `Namaste4000##` | Email marketing, newsletter campaigns |
| **JotForm** | `subconscioussurgery@gmail.com` | `Kunda123**` | Online client intake and feedback forms |
| **PDFescape** | `subconscioussurgery@gmail.com` | `Kunda123**` | Editable PDF contract design |
| **PDFFiller** | `subconscioussurgery@gmail.com` | `Kunda123` | Completed contract processing and archive |
| **Gmail (Admin)** | `subconscioussurgery@gmail.com` | `Namaste3000` | Primary administrative email bridge |
| **Twitter** | `@subconsurgery` | `Namaste4000` | Public social media channel |
| **Facebook** | `challengeyourreality@yahoo.com`| `Namaste4000##` | Public marketing pages |

### 5.2 Server and Database Architecture
- **Primary Domain:** `subconscioussurgery.com` (pointing to IP `109.228.48.163` via Heart Internet registrar).
- **FTP Folder Structure:**
  - `/public_html/` — WordPress core installation directory.
  - `/public_html/wp-content/uploads/agreements/` — Private folder for signed intake PDFs.
  - `/public_html/wp-content/themes/subcon-child/` — Custom child theme containing custom CSS styles and BNI landing page templates.
- **MySQL Database:** `subconsc_wp1` (username: `subconsc_user1` / password: `Db%92!kK#p01`). Serves the WordPress core, contact form entries, and historical blog posts.

---

## 6. Governance & Strict Firewalls

All operations, documentation, and syntheses of Subconscious Surgery must strictly adhere to the following governance and security firewalls:

### 6.1 The §7 Ex-Spouse Name Quarantine
- **Boundary:** The name of the ex-spouse (**Chelsea**) must be absolutely quarantined and never written, referenced, or included in any file, table, timeline, or index across any project, unless explicitly required in sealed legal evidence folders.
- **Attribution:** Traditional business associates, networking group members, or corporate stakeholders (such as Helen Blackburn, Ellie, or Helen Nachintu) are to receive normal, objective, and professional attribution.

### 6.2 The Voital Internal-Only Firewall
- **Boundary:** The term "**Voital**" is strictly designated as working-internal only.
- **Constraint:** Under no circumstances may the term "Voital" appear in any customer-facing, public-facing, or marketing-related materials, websites, books, or sales funnels. All public facing terminology must utilize standard terms such as "somatic performance coaching," "mindset coaching," or "subconscious alignment."

### 6.3 The Somatic Methodology Firewall
- **Boundary:** Somatic kinesiology, muscle testing, and proxy surrogate testing must be presented strictly as subjective "somatic coaching indicators" and "metaphoric indicators" utilised within historical coaching sessions to help clients identify areas of physical tension and emotional stress.
- **Constraint:** Under no circumstances should these methods be framed as scientifically verified diagnostic, medical, or psychological treatments in any public or top-of-funnel surfaces. The detailed technical explanations of these protocols are strictly confined to internal, paid student coursework documents, such as the SSTP syllabus, ensuring the protection of corporate IP without violating public advertising standards.

### 6.4 Fastidious Language Standards
- **Boundary:** All canonical documents must be written in high-quality, professional British English.
- **Constraint:** Ensure spelling conventions strictly utilize British forms (e.g., `programme`, `organise`, `centre`, `jewellery`, `synthesis`, `characterise`, `prioritise`) rather than American variants.
