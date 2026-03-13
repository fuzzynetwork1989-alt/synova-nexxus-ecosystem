#!/usr/bin/env node

const Ajv = require('ajv');
const fs = require('fs');
const path = require('path');

const ajv = new Ajv({ allErrors: true });

// Schema for synova.app.json
const synovaAppSchema = {
  type: 'object',
  properties: {
    name: { type: 'string', minLength: 1 },
    slug: { type: 'string', pattern: '^[a-z0-9-]+$' },
    status: { enum: ['prototype', 'alpha', 'beta', 'stable', 'deprecated'] },
    description: { type: 'string', minLength: 1 },
    tags: { type: 'array', items: { type: 'string' }, minItems: 1 },
    repo: { type: 'string', format: 'uri' },
    homepage: { type: 'string', format: 'uri' },
    demo: {
      type: 'object',
      properties: {
        video: { type: 'string' },
        screenshots: { type: 'array', items: { type: 'string' } }
      }
    },
    tech: { type: 'array', items: { type: 'string' } },
    created_at: { type: 'string', format: 'date' },
    supanova: {
      type: 'object',
      properties: {
        enabled: { type: 'boolean' },
        tools: { type: 'array', items: { type: 'string' } },
        context_feed: { type: 'boolean' },
        permissions: {
          type: 'object',
          properties: {
            destructive_actions: { enum: ['confirmation_required', 'auto_allowed', 'disabled'] }
          }
        }
      },
      required: ['enabled', 'tools', 'context_feed']
    }
  },
  required: ['name', 'slug', 'status', 'description', 'tags', 'repo', 'created_at', 'supanova'],
  additionalProperties: false
};

function validateFile(filePath, schema) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const data = JSON.parse(content);
    
    const validate = ajv.compile(schema);
    const valid = validate(data);
    
    if (!valid) {
      console.error(`❌ Validation failed for ${filePath}:`);
      console.error(JSON.stringify(validate.errors, null, 2));
      return false;
    }
    
    console.log(`✅ ${filePath} is valid`);
    return true;
  } catch (error) {
    console.error(`❌ Error validating ${filePath}:`, error.message);
    return false;
  }
}

function main() {
  console.log('🔍 Validating Synova app manifests...');
  
  let allValid = true;
  
  // Validate synova.app.json
  const manifestPath = path.join(process.cwd(), 'synova.app.json');
  if (!fs.existsSync(manifestPath)) {
    console.error('❌ synova.app.json not found');
    allValid = false;
  } else {
    allValid = validateFile(manifestPath, synovaAppSchema) && allValid;
  }
  
  // Check required Supanova files
  const requiredFiles = [
    'supanova/manifest.json',
    'supanova/tools/index.ts',
    'supanova/context/emitter.ts',
    'supanova/context/schema.json',
    'supanova/policies/permissions.json',
    'supanova/policies/guardrails.md',
    'SUPANOVA_INTEGRATION.md'
  ];
  
  for (const file of requiredFiles) {
    const filePath = path.join(process.cwd(), file);
    if (!fs.existsSync(filePath)) {
      console.error(`❌ Required file missing: ${file}`);
      allValid = false;
    } else {
      console.log(`✅ Required file present: ${file}`);
    }
  }
  
  // Validate Supanova tools exist
  const toolsPath = path.join(process.cwd(), 'supanova/tools/index.ts');
  if (fs.existsSync(toolsPath)) {
    const toolsContent = fs.readFileSync(toolsPath, 'utf8');
    const requiredTools = ['app.search', 'app.summarize', 'app.create_or_update', 'app.navigate', 'app.settings'];
    
    for (const tool of requiredTools) {
      if (!toolsContent.includes(tool)) {
        console.error(`❌ Required tool missing: ${tool}`);
        allValid = false;
      } else {
        console.log(`✅ Required tool present: ${tool}`);
      }
    }
  }
  
  if (allValid) {
    console.log('🎉 All validations passed!');
    process.exit(0);
  } else {
    console.log('💥 Validation failed!');
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { validateFile, synovaAppSchema };
