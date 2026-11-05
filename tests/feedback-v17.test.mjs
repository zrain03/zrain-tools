import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,readdir} from 'node:fs/promises';
const root=new URL('../',import.meta.url);
test('legacy GitHub Issues feedback module is not built or published',async()=>{
 for(const group of ['zrain-image-tools','zrain-pdf-tools','zrain-document-tools','zrain-developer-tools','zrain-productivity-tools']){
  const files=await readdir(new URL(`../dist/${group}/`,import.meta.url));
  assert.ok(!files.includes('feedback-embed.js'));
  assert.ok(!files.includes('feedback.css'));
 }
});
test('new pages use externally maintained official Community widget',async()=>{
 const s=await readFile(new URL('../src/build.mjs',import.meta.url),'utf8');
 assert.match(s,/https:\/\/zrain-community\.web\.app\/embed\.js/);
 assert.match(s,/data-target/);
 assert.doesNotMatch(s,/github\.com\/zrain03\/zrain-ecosystem\/issues/);
});
