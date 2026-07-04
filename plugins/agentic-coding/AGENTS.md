# Team Agent Standards

Shared instructions for coding agents (Claude Code, Codex) working across team projects.

## Conventions

- (fill in: commit style, branch naming, PR expectations)

## Architecture notes

- (fill in: cross-cutting patterns agents should know about)

## Form Validation

- Keep all field-validation logic for a given form in **one place** — never split it between the UI framework's native form rules and a separate schema (e.g. zod) for the same field.
- Zod is the single source of truth for validation. Don't hand-write the UI framework's native rules (e.g. antd `Form` `rules`) alongside a zod schema — derive the framework's rules from the schema instead.
- Translate the schema into framework rules through one small shared adapter (re-parse the current values, map the resulting issue back to the field by path) rather than one-off wiring per form. The framework's job is only to render whatever error the schema produced.
- Before writing this adapter, check whether the project already has one — search for an existing `zodRule`-style helper (typically under a shared `utils`/`lib` directory) rather than reimplementing it per form or per project.
- Cross-field checks (e.g. confirm-password) belong in the schema itself (`.refine()` with `path: [...]`), not as bespoke per-field logic in the form layer.
- The same schema should also be reused wherever else that shape applies — the API request payload, another form, a standalone unit test — rather than redefined.

## Data contracts (schemas, types, API responses)

- Model one entity with **one base schema**, then derive every variant from it instead of hand-writing separate types that duplicate the same fields — `.pick()` for a create/update input subset, `.extend()` for a list/detail view with extra computed fields, `.partial()` for optional-update shapes. If two schemas repeat the same field definition, one of them should be derived from the other.
- Validate API *responses*, not just requests/forms: parse `fetch`/`res.json()` results through the same zod schema (`schema.parse(...)`) instead of an unchecked `as Promise<T>` cast. A cast lies silently when the backend contract drifts; `.parse()` fails loudly at the boundary.
- When a backend response field stops being used by any caller, remove it from the contract on both sides (response schema/model *and* frontend type) rather than leaving dead fields "just in case." Check every caller of a mutation's return value before deciding it needs one — if nothing reads it, the mutation can resolve `void`.
- When a list endpoint needs only a count/aggregate of a related table (not the related rows themselves), query with `COUNT`/aggregate rather than fetching full related rows and taking `len()` in Python/JS — especially inside a per-item loop, where fetching full rows compounds an already-present N+1 query pattern.

## Database constraints vs. application logic

- Before adding an application-level existence check ("does a referencing row exist?") ahead of a delete/update, check what the DB already enforces. A foreign key with no `ondelete` (or `ondelete=RESTRICT`) already blocks the operation on its own — a pre-check duplicating that is redundant work and an extra round-trip.
- Where the DB already blocks the operation, don't pre-query for it — attempt the write, catch the resulting `IntegrityError` (or provider equivalent), and translate it into a clean API error (e.g. 409 with a message). Let the constraint be the single source of truth; the try/except is just there to make the failure mode presentable.
- Only write real application-level logic when the rule is something a plain constraint cannot express — e.g. "block only if a related row's `status` is `active`" is conditional on a column value, which a FK constraint has no way to encode. That kind of rule has to live in code (or a DB trigger/partial constraint, which is usually more complexity than it's worth for one rule).
- When a business rule simplifies (e.g. a stakeholder says "I don't care about status, block on *any* link" instead of a conditional rule), re-check whether the app-level check that used to be necessary is now redundant with something the DB already guarantees — simplifying the rule can mean deleting code, not just editing it.

## Styling (CSS-in-JS / component libraries)

- Don't override a component library's internal/generated CSS classes (e.g. antd's `.ant-*`) unless absolutely required. Prefer the library's own default spacing and props first; fighting its class specificity is a sign the wrong element is being styled.
- Use CSS-in-JS (`styled-components`/`@emotion/styled`) for layout and for overriding/extending library components — not to reimplement primitives (buttons, inputs, form fields) the library already provides natively.
- Use the theme's design tokens/CSS variables for spacing and sizing (e.g. antd's `var(--ant-margin-*)`, `var(--ant-padding-*)`) instead of hardcoded pixel values, snapping to the nearest defined step rather than inventing one-off values.
- No inline `style={{...}}` props mixed into JSX for anything beyond a genuinely dynamic, per-render value — static styling belongs in a styled component.

## Avoiding duplication

- Don't prematurely abstract — three similar lines across one file is fine. But once the same block (styled components, helper functions, validation logic) is copy-pasted verbatim across multiple files, extract it into a shared module rather than letting the copies drift.
- When stripping out bad or over-engineered customization from an existing component, prefer a clean rewrite over a minimal patch — patching around a bad pattern usually just adds a second bad pattern on top of it.

## Workflow

- (fill in: how agents should verify changes, testing expectations)
- After any code change, run the project's typecheck and lint before considering the task done (see the project's own CLAUDE.md/AGENTS.md for exact commands).
